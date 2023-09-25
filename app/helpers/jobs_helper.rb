module JobsHelper
  def job_info_or_apply_link(job, size = "sm")
    return unless job
    if job.description&.length && job.description&.length > 500
      link_to "Apply",
              create_application_job_path(job),
              class: "btn btn-success btn-#{size} float-end"
    else
      link_to "MORE INFO", get_details_job_path(job), class: "btn btn-info"
    end
  end
end
