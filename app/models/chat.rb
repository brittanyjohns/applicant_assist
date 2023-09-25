# == Schema Information
#
# Table name: chats
#
#  id          :bigint           not null, primary key
#  source_type :string           not null
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  source_id   :bigint           not null
#  user_id     :bigint           not null
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
    subjects_to_filter = message_types << "System Setup"
    messages.where.not(subject: subjects_to_filter)
  end

  def message_types
    ["Interview Tips", "Company Info", "Resume Re-Write", "Resume Intro", "Elevator Speech"]
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

  def format_messages
    if messages.blank?
      [Message.create_initial_setup_prompt_for(self.id)]
    else
      messages.map do |msg|
        { role: msg.role, content: msg.content }
      end
    end
  end

  def prompt
    messages.last&.content || title || "Hello there AI dude."
  end

  def user_resume
    user.resume
  end

  def interview_tips
    messages.where(subject: "Interview Tips", role: "assistant").last&.displayed_content || "<p>No Interview Tips yet</p>".html_safe
  end

  def resume_rewrite
    messages.where(subject: "Resume Re-Write", role: "assistant").last&.displayed_content || "<p>No Resume Re-Write yet</p>".html_safe
  end

  def resume_intro
    messages.where(subject: "Resume Intro", role: "assistant").last&.displayed_content || "<p>No Resume Intro yet</p>".html_safe
  end

  def elevator_speech
    messages.where(subject: "Elevator Speech", role: "assistant").last&.displayed_content || "<p>No Elevator Speech yet</p>".html_safe
  end

  def company_info
    messages.where(subject: "Company Info", role: "assistant").last&.displayed_content || "<p>No Company Info yet</p>".html_safe
  end

  def open_ai_opts
    { prompt: prompt[0...MAX_TOKEN_LENGTH], messages: format_messages }
  end

  def job_posting
    job_posting_details = source.job.description
    puts "MISSING JOB DESCRIPTION" unless job_posting_details
    job_posting_details
  end

  def job_title
    title = source.job.title
    puts "MISSING JOB TITLE" unless title
    title
  end

  def company_name
    company_name = source.job.company.name
    puts "MISSING COMPANY NAME" unless company_name
    company_name
  end

  def chat_with_ai!
    puts "Chatting with AI with parmas: #{open_ai_opts}"

    response = OpenAiClient.new(open_ai_opts).create_chat
    puts "Totals response: #{response.inspect}\n\n"
    if response && response[:role]
      role = response[:role] || "assistant"
      content = response[:content]

      # self.save!

      # new_line_regex = /\n/
      last_user_msg = messages.where(role: "user").last
      subject = last_user_msg ? last_user_msg.subject : "Hello Human"

      msg = messages.find_or_initialize_by(role: role, subject: subject)
      msg.content = content
      # new_line_regex = /\n/
      # replaced_text = content.gsub(new_line_regex, "<br>") if content

      # puts replaced_text
      msg.displayed_content.body = content
      puts msg.inspect

      msg.save!
    else
      puts "**** ERROR **** \nDid not receive valid response.\n"
    end
    self
  end
end
