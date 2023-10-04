class JobDetailsJob
  include Sidekiq::Job
  sidekiq_options queue: "default", retry: 2, backtrace: true

  def perform(web_id)
    description = Indeed.new(nil, nil, nil, web_id).get_details

    unless description && description.length > 500
      raise "Job description not found for #{web_id} - \n #{description}\n"
    end
    job = Job.find_by(web_id: web_id)
    raise "Job not found for #{web_id}" unless job
    job.description = description
    job.displayed_job_description.body = description
    job.save!
  end
end
