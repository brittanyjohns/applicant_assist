module JobsHelper
  def job_info_or_apply_link(job, size = "sm")
    return unless job
    if job.has_all_details?
      link_to "Apply",
              new_job_application_path(job),
              class: "btn btn-success btn-#{size} float-end"
    else
      link_to "MORE INFO", get_details_job_path(job), class: "btn btn-info"
    end
  end
end
