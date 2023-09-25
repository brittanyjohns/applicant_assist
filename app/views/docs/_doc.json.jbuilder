json.extract! doc, :id, :name, :doc_type, :body, :raw_body, :documentable_id, :documentable_type, :current, :created_at, :updated_at
json.url doc_url(doc, format: :json)
