json.extract! contact, :id, :name, :email, :company_name, :job_title, :created_at, :updated_at
json.url contact_url(contact, format: :json)
