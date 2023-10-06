# == Schema Information
#
# Table name: chats
#
#  id                   :bigint           not null, primary key
#  source_type          :string           not null
#  title                :string
#  total_token_usd_cost :decimal(, )      default(0.0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  source_id            :bigint           not null
#  user_id              :bigint           not null
#
# Indexes
#
#  index_chats_on_source   (source_type,source_id)
#  index_chats_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true
  has_many :messages, dependent: :destroy
  after_create_commit { broadcast_append_to("chats") }

  MAX_TOKEN_LENGTH = 4000 # its actually 4097 but  - round numbers :)

  def application
    self.source if source.class.name == "Application"
  end

  def messages_to_display
    messages.where.not(subject: subjects_to_filter)
  end

  def subjects_to_filter
    inactive_message_types << "System Setup"
  end

  def message_types
    Prompt.active.pluck(:subject).sort
  end

  def inactive_message_types
    Prompt.inactive.pluck(:subject).sort
  end

  def remaining_prompt_types
    completed_prompts = messages.where(subject: message_types).pluck(:subject)
    message_types - completed_prompts
  end

  def text_format
    " Format all responses as rich text unless otherwise instructed."
  end

  def short_responses
    "You keep all of your responses short & to the point."
  end

  def chat_room_messages
    messages.where(subject: nil)
  end

  def format_messages
    messages_to_format = Message.find_or_create_setup_prompts_for(self.id)
    last_user_msg = self.messages.user_messages.last
    Rails.logger.debug "LAST USER MSG: #{last_user_msg.inspect}"
    messages_to_format << last_user_msg if last_user_msg
    Rails.logger.debug "messages_to_format: #{messages_to_format.count}"
    messages_to_format.map do |msg|
      { role: msg.role, content: msg.content }
    end
  end

  def prompt
    messages.last&.content || title || "Hello there AI dude."
  end

  def user_resume
    user.resume
  end

  def message_for(subject)
    messages.where(subject: subject.titleize).last&.displayed_content || "<p>***No #{subject.titleize} yet</p>".html_safe
  end

  def open_ai_opts
    { prompt: prompt[0...MAX_TOKEN_LENGTH], messages: format_messages }
  end

  def job_posting
    job_posting_details = source.job.description
    Rails.logger.debug "MISSING JOB DESCRIPTION" unless job_posting_details
    job_posting_details
  end

  def job_title
    title = source.job.title
    Rails.logger.debug "MISSING JOB TITLE" unless title
    title
  end

  def company_name
    company_name = source.job.company.name
    Rails.logger.debug "MISSING COMPANY NAME" unless company_name
    company_name
  end

  def over_token_limit?
    Rails.logger.debug "total_token_usd_cost: #{total_token_usd_cost} - prompt.length: #{prompt.length} - MAX_TOKEN_LENGTH: #{MAX_TOKEN_LENGTH}"
    total_token_usd_cost > MAX_TOKEN_LENGTH || prompt.length > MAX_TOKEN_LENGTH
  end

  def chat_with_ai!
    ai_client = OpenAiClient.new(open_ai_opts)
    response = ai_client.create_chat
    if response && response[:role]
      role = response[:role] || "assistant"
      content = response[:content]

      # self.save!

      # new_line_regex = /\n/
      last_user_msg = messages.where(role: "user").last
      subject = last_user_msg ? last_user_msg.subject : "Hello Human"

      Rails.logger.debug "\n\ncreating new message with role: #{role} and subject: #{subject}\n\n"

      msg = messages.new(role: role, subject: subject)
      msg.content = content
      new_line_regex = /\n/
      replaced_text = content.gsub(new_line_regex, "<br>") if content

      Rails.logger.debug replaced_text
      msg.displayed_content.body = replaced_text
      msg.update_token_stats!(response)
    else
      Rails.logger.debug "*** ERROR *** \nDid not receive valid response.\n"
    end
  end
end
