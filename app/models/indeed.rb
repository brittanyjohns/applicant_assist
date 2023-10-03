require "open-uri"
require "nokogiri"
require "rails"
require "httparty"

class Indeed
  attr_accessor :request_type
  include HTTParty

  def initialize(search_term, location = "Remote", radius = nil, job_web_id = nil)
    @options = { query: { q: search_term, l: location, radius: radius }, job_web_id: job_web_id }
    @request_type = job_web_id ? :view : :search
  end

  def build_url
    query_data = @options[:query]
    query_params = query_data.to_query
    "https://www.indeed.com/jobs?#{query_params}"
  end

  def payload
    {
      "api_key": ENV.fetch("PAGE2API_API_KEY"),
      "url": build_url,
      "real_browser": true,
      "merge_loops": true,
      "scenario": [
        {
          "loop": [
            {
              "wait_for": "div.jobsearch-QueryReplaceContainer",
            },
            {
              "execute": "parse",
            },
            {
              "execute_js": "var next = document.querySelector('[data-testid=pagination-page-next]'); if(next) { next.click() }",
            },
          ],
          "iterations": 5,
          "stop_condition": "document.querySelector('[data-testid=pagination-page-next]') == null",
        },
      ],
      "parse": {
        "jobs": [
          {
            "_parent": "div.resultWithShelf",
            "link": "a >> href",
            "web_id": "a >> id",
            "title": "span >> text",
            "salary": ".salaryOnly >> text",
            "snippet": ".job-snippet >> text",
            "company_name": ".companyName >> text",
            "company_location": ".companyLocation >> text",
          },
        ],
      },
    }
  end

  def api_url
    "https://www.page2api.com/api/v1/scrape"
  end

  def search
    Rails.logger.debug "Indeed search payload: #{payload}"
    response = HTTParty.post(api_url, body: payload.to_json, headers: { "Content-Type" => "application/json" }).body

    result = JSON.parse(response)
    Rails.logger.debug "Indeed search result: #{result}"

    job_results = result["result"]
    return unless job_results
    jobs = job_results["jobs"]
    count = 0
    return unless jobs
    jobs.each do |job_info|
      break if count > 50
      count += 1
      title = job_info["title"]
      link = job_info["link"]
      web_id = job_info["web_id"]
      salary = job_info["salary"]
      snippet = job_info["snippet"]
      company_name = job_info["company_name"]
      company_location = job_info["company_location"]
      company = Company.find_or_create_by(name: company_name)
      job = company.jobs.find_by(web_id: web_id)
      if job
        same_title = title && (title === job.title)
        puts "Job already exists same_title: #{same_title} \n#{job.inspect}\nresponse: #{job_info}"

        job.update(title: title) unless same_title
      else
        job = company.jobs.new(title: title, web_link: link, web_id: web_id, salary: salary, description: snippet, location: company_location)
        job.save!
      end
    end
  end

  def build_view_url(job_web_id)
    stripped_job_web_id = job_web_id.split("_")[1]
    puts "stripped_job_web_id: #{stripped_job_web_id}"
    "https://www.indeed.com/viewjob?jk=#{stripped_job_web_id}"
  end

  def view_payload
    {
      "api_key": ENV.fetch("PAGE2API_API_KEY"),
      "url": build_view_url(@options[:job_web_id]),
      "real_browser": true,
      "merge_loops": true,
      "scenario": [
        {
          "loop": [
            {
              "wait_for": "div.jobsearch-JobComponent",
            },
            {
              "execute": "parse",
            },
            {
              "execute_js": "var next = document.querySelector('[data-testid=pagination-page-next]'); if(next) { next.click() }",
            },
          ],
          "iterations": 1,
        },
      ],
      "parse": {
        "description": "#jobDescriptionText",
      },
    }
  end

  def get_details
    response = HTTParty.post(api_url, body: view_payload.to_json, headers: { "Content-Type" => "application/json" }).body

    result = JSON.parse(response)
    puts result

    job_details = result["result"]
    description = job_details["description"] if job_details
    will_retry = true

    # File.open("job_details.txt", "w") { |f| f.write "#{Time.now} - #{job.id} job_details\n#{job_details}\n" }
    description
  end
end
