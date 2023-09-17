require "open-uri"
require "nokogiri"
require "rails"
require "httparty"

class Indeed
  attr_accessor :search_term
  include HTTParty

  def initialize(search_term, location = "Remote", radius = nil)
    @options = { query: { q: search_term, l: location, radius: radius } }
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
    response = HTTParty.post(api_url, body: payload.to_json, headers: { "Content-Type" => "application/json" }).body

    result = JSON.parse(response)

    job_results = result["result"]
    return unless job_results
    jobs = job_results["jobs"]
    return unless jobs
    jobs.each do |job_info|
      title = job_info["title"]
      link = job_info["link"]
      web_id = job_info["web_id"]
      salary = job_info["salary"]
      snippet = job_info["snippet"]
      company_name = job_info["company_name"]
      company_location = job_info["company_location"]
      job = Job.find_by(web_id: web_id)
      if job
        puts "Job already exists - skipping"
      else
        company = Company.find_or_create_by(name: company_name)
        job = company.jobs.new(title: title, web_link: link, web_id: web_id, salary: salary, description: snippet, location: company_location)
        job.save!
      end
    end
  end
end
