json.extract! chat, :id, :user_id, :source_id, :source_type, :title, :created_at, :updated_at
json.url chat_url(chat, format: :json)
