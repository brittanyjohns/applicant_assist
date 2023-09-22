# == Schema Information
#
# Table name: messages
#
#  id            :bigint           not null, primary key
#  content       :text
#  date_received :string
#  from          :string
#  role          :string
#  subject       :string
#  to            :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  chat_id       :integer
#
class Message < ApplicationRecord
  has_rich_text :displayed_content
  belongs_to :chat
  validates :role, presence: true
  before_save :save_rich_content, if: :missing_content
  before_save :ensure_role
  broadcasts_to :chat, target: "messages"

  def ensure_role
    self.role ||= 'user'
  end

  def save_rich_content
    if content
      puts "setting display text"
      new_line_regex = /\n/
      replaced_text = content.gsub(new_line_regex, "<br>")

      puts replaced_text
      self.displayed_content.body = replaced_text
    end
  end

  def missing_content
    displayed_content.nil? || displayed_content.body.blank?
    true
  end
end
