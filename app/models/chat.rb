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

  def application
    self.source if source.class.name == "Application"
  end

  def messages_to_display
    messages.where(subject: nil)
  end

  def message_types
    ["Interview Tips", "Company Info"]
  end

  def text_format
    " Format all responses as rich text unless otherwise instructed."
  end

  def short_responses
    "You keep all of your responses short & to the point."
  end

  def format_messages
    if messages.blank?
      [messages.create!(role: "system", subject: "System Setup", content: "You are a funny and sarcastic, but also very helpful, assistant that is going to help me get the job described in the following job posting:\n #{job_posting}\n\n")]
    else
      messages.map do |msg|
        { role: msg.role, content: msg.content }
      end
    end
  end

  def prompt
    messages.last&.content || title || "Hello there AI dude."
  end

  def interview_tips
    messages.where(subject: "Interview Tips", role: "assistant").last&.content&.html_safe || "<p>No Interview Tips yet</p>"
  end

  def company_info
    messages.where(subject: "Company Info", role: "assistant").last&.content&.html_safe || "<p>No Company Info yet</p>"
  end

  def open_ai_opts
    { prompt: prompt, messages: format_messages }
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
      last_user_msg = messages.where(role: "user").last&.subject
      puts "last_user_msg: #{last_user_msg}"
      msg = messages.new(role: role, content: content, subject: last_user_msg)
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
