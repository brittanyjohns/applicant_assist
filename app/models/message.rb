class Message < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  after_save :save_content

  def self.email_id_exists?(id)
    self.where(message_id: id).exists?
  end

  def save_content
    return unless body && id
    rich_text_content = ActionText::RichText.find_or_initialize_by(record_type: "Message", record_id: id, name: "content", body: body)
    rich_text_content.save!
  end
end
