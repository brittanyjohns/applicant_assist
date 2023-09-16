json.extract! job, :id, :company_id, :title, :description, :location, :salary, :job_type, :experience, :favorite, :rating, :status, :created_at, :updated_at
json.url job_url(job, format: :json)
