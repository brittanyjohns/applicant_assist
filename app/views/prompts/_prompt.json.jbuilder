json.extract! prompt, :id, :subject, :body, :active, :created_at, :updated_at
json.url prompt_url(prompt, format: :json)
