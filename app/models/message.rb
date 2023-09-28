# == Schema Information
#
# Table name: messages
#
#  id                    :bigint           not null, primary key
#  completion_token_cost :integer          default(0)
#  content               :text
#  date_received         :string
#  from                  :string
#  in_reply_to           :integer
#  prompt_token_cost     :integer          default(0)
#  role                  :string
#  subject               :string
#  to                    :string
#  total_token_cost      :integer          default(0)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  chat_id               :integer
#
class Message < ApplicationRecord
  attr_accessor :resume_sent
  has_rich_text :displayed_content
  belongs_to :chat
  validates :role, presence: true
  before_save :ensure_role
  after_save :update_chat_total_tokens
  # broadcasts_to :chat, target: "messages"
  # broadcasts_to ->(message) { :message_list }, inserts_by: :prepend, target: message

  after_create_commit :update_message_content

  def update_chat_total_tokens
    puts "Updating chat total tokens"
    chat.update(total_token_cost: chat.messages.sum(:total_token_cost))
  end

  def ensure_role
    self.role = "user" if self.role.blank?
  end

  def setup_user_prompt(prompt_type)
    self.role = "user"
    self.subject = prompt_type
    build_prompt
    self
  end

  def job_posting
    job_posting_details = chat.job_posting
    puts "MISSING JOB DESCRIPTION" unless job_posting_details
    job_posting_details
  end

  def job_title
    title = chat.job_title
    puts "MISSING JOB TITLE" unless title
    title
  end

  def company_name
    company_name = chat.company_name
    puts "MISSING COMPANY NAME" unless company_name
    company_name
  end

  def detailed_response
    Prompt.where(subject: "Detailed Response").first&.body || "Provide as much detail as possible. I understand you are an AI language model with limitations, so any company information you have available will work."
  end

  def bootstrap_styling
    " styled using Bootstrap css helpers"
  end

  def company_info_table_id
    "company_#{chat.source.job.company.id}"
  end

  def table_id
    "#{self.subject.downcase}_for_job_#{chat.source.job.id}"
  end

  def build_prompt
    prompt = Prompt.where(subject: self.subject.titleize).first
    raise "Unknown Prompt Type for #{self.subject.titleize}" unless prompt
    replace_prompt_text(prompt.body)
    # "Tell me 3 things that would be helpful for someone applying to #{company_name} as a #{job_title} to know about the company. Include things like mission statement, culture, industry, short summary of what they do, office locations (if applicable) & any other useful information. #{detailed_response}"
  end

  def self.keys_to_replace
    %w(COMPANY_NAME JOB_TITLE DETAILED_RESPONSE JOB_POSTING USER_RESUME)
  end

  def replace_prompt_text(prompt_text)
    puts "prompt_text: #{prompt_text}"
    Message.keys_to_replace.each do |key|
      prompt_text.gsub!(key, send(key.downcase.to_sym))
      puts "REPLACING #{key} with #{send(key.downcase.to_sym)}"
    end
    self.content = prompt_text
  end

  def user_resume
    chat.user_resume&.displayed_content&.body&.to_plain_text || "No Resume Attached"
  end

  def self.create_initial_setup_prompt_for(chat_id)
    sys_msg = new(chat_id: chat_id,
                  role: "system",
                  subject: "Initial System Setup")
    sys_msg.replace_prompt_text(sys_msg.initial_system_setup)
    puts "Saving SYS MESAGE: #{sys_msg.inspect}"
    sys_msg.save!
    usr_msg = new(chat_id: chat_id,
                  role: "user",
                  subject: "Initial User Setup")
    usr_msg.build_prompt
    usr_msg.save!
    [sys_msg, usr_msg]
  end

  def initial_system_setup
    Prompt.where(subject: "Initial System Setup").first&.body || "I will help you get at the job described in the following job posting:\n JOB_POSTING\nAnd here's your resume I will use for future reference:\n USER_RESUME"
  end

  def formatted_as_table(table_id)
    "Please format the response as a HTML table. Only include html table with the id of #{table_id} and #{bootstrap_styling} in the response."
  end

  def update_message_content
    puts "Updating message content for #{self.subject}"
    broadcast_update_to(:message_list, inserts_by: :replace, target: self.subject.downcase.split.join("_"), html: "<div id='#{self.subject.downcase.split.join("_")}' class='turbo-replaced-details'><h3>#{self.subject}</h3>#{self.displayed_content.body}</div>")
    # return if self.role == "user" && self.chat.message_types.include?(self.subject.titleize)
    # broadcast_update_to(self.chat, :messages, target: self.subject.downcase.split.join("_"), html: "<div id='#{self.subject.downcase.split.join("_")}' class='scrolling-details'><h3>#{self.subject}</h3>#{self.displayed_content.body}</div>")
  end

  def update_token_stats!(response)
    puts "Updating token stats for #{self.subject}"
    self.prompt_token_cost = response[:prompt_tokens]
    self.completion_token_cost = response[:completion_tokens]
    self.total_token_cost = response[:total_tokens]
    self.save!
  end
end
