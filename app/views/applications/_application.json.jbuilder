json.extract! application, :id, :user_id, :job_id, :status, :stage, :applied_at, :archived_at, :job_source, :job_link, :company_link, :favorite, :rating, :details, :notes, :created_at, :updated_at
json.url application_url(application, format: :json)
