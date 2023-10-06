# == Schema Information
#
# Table name: messages
#
#  id                     :bigint           not null, primary key
#  completion_tokens_cost :decimal(, )      default(0.0)
#  content                :text
#  date_received          :string
#  from                   :string
#  in_reply_to            :integer
#  prompt_tokens_cost     :decimal(, )      default(0.0)
#  role                   :string
#  subject                :string
#  to                     :string
#  total_token_cost       :decimal(, )      default(0.0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  chat_id                :integer
#
class Message < ApplicationRecord
  has_rich_text :displayed_content
  belongs_to :chat
  validates :role, presence: true
  after_save :update_chat_total_tokens
  before_validation :ensure_role
  # broadcasts_to :chat, target: "messages"
  broadcasts_to ->(message) { :chat_message }, inserts_by: :prepend, target: "chat_messages"

  INITIAL_SYSTEM_SETUP = "Initial System Setup"
  INITIAL_USER_SETUP = "Initial User Setup"

  scope :user_messages, -> { where(role: "user") }
  scope :assistant_messages, -> { where(role: "assistant") }
  scope :system_messages, -> { where(role: "system") }
  scope :without_intial_setup_messages, -> { where.not(subject: [INITIAL_SYSTEM_SETUP, INITIAL_USER_SETUP]) }
  scope :without_prompt_messages, -> { where.not(subject: Prompt.prompt_subject_list) }
  scope :display_to_user, -> { assistant_messages.without_intial_setup_messages }
  scope :chat_room_messages, -> { without_intial_setup_messages.without_prompt_messages }

  after_create_commit :update_message_content

  def update_chat_total_tokens
    Rails.logger.debug "Updating chat total tokens"
    chat.update(total_token_usd_cost: chat.messages.sum(:total_token_cost))
  end

  def self.chat_bot_welcome
    self.where(role: "assistant", subject: INITIAL_USER_SETUP).first&.displayed_content&.body || "Welcome to the chat bot! I will be your assistant for this application."
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
    Rails.logger.debug "MISSING JOB DESCRIPTION" unless job_posting_details
    job_posting_details
  end

  def job_title
    title = chat.job_title
    Rails.logger.debug "MISSING JOB TITLE" unless title
    title
  end

  def company_name
    company_name = chat.company_name
    Rails.logger.debug "MISSING COMPANY NAME" unless company_name
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
    Message.keys_to_replace.each do |key|
      prompt_text.gsub!(key, send(key.downcase.to_sym))
    end
    self.content = prompt_text
  end

  def user_resume
    chat.user_resume&.displayed_content&.body&.to_plain_text || "No Resume Attached"
  end

  def self.create_initial_setup_prompt_for(chat_id)
    sys_msg = new(chat_id: chat_id,
                  role: "system",
                  subject: INITIAL_SYSTEM_SETUP)
    sys_msg.replace_prompt_text(sys_msg.initial_system_setup)
    sys_msg.save!
    usr_msg = new(chat_id: chat_id,
                  role: "user",
                  subject: INITIAL_USER_SETUP)
    usr_msg.build_prompt
    usr_msg.save!
    [sys_msg, usr_msg]
  end

  def self.find_or_create_setup_prompts_for(chat_id)
    sys_msg = Message.where(chat_id: chat_id, role: "system", subject: INITIAL_SYSTEM_SETUP)
    usr_msg = Message.where(chat_id: chat_id, role: "user", subject: INITIAL_USER_SETUP)
    if sys_msg.blank? || usr_msg.blank?
      sys_msg, usr_msg = create_initial_setup_prompt_for(chat_id)
    end
    [sys_msg, usr_msg].flatten
  end

  def initial_system_setup
    Prompt.where(subject: INITIAL_SYSTEM_SETUP).first&.body || "I will help you get at the job described in the following job posting:\n JOB_POSTING\nAnd here's your resume I will use for future reference:\n USER_RESUME"
  end

  def formatted_as_table(table_id)
    "Please format the response as a HTML table. Only include html table with the id of #{table_id} and #{bootstrap_styling} in the response."
  end

  def id_name
    if self.subject
      "#{self.subject.downcase.split.join("_")}_#{self.id}"
    else
      "#{self.role}_message_#{self.id}"
    end
  end

  def subject_title
    if self.subject
      self.subject.downcase.split.join("_")
    else
      "#{self.role}_message_#{self.id}"
    end
  end

  def content_to_display
    self.displayed_content&.body&.html_safe || self.content&.html_safe || "No content to display"
  end

  def print_token_info
    "Completion Tokens Cost: #{self.completion_tokens_cost} - Prompt Tokens Cost: #{self.prompt_tokens_cost} - Total Token Cost: #{self.total_token_cost}"
  end

  def update_message_content
    Rails.logger.debug "Updating message content for #{self.subject} - #{subject_title}"
    broadcast_append_to "messages"
    # broadcast_update_to(:message_list, inserts_by: :replace, target: "accordion_body_#{id_name}", html: "#{self.displayed_content.body}")
    # render partial: "messages/accordion_item", locals: { id_name: "chat_bot_welcome", subject: "Welcome", chat: @app_chat }
    # broadcast_update_to(:message_list, inserts_by: :prepend, target: "messages", partial: "messages/message", locals: { message: self }) if self.role == "assistant"
    # format.turbo_stream { render turbo_stream: turbo_stream.replace("form", partial: "posts/form", locals: { conversation: @conversation, post: Post.new }) }

    # return if self.role == "user" && self.chat.message_types.include?(self.subject.titleize)
    # broadcast_update_to(self.chat, :messages, target: self.subject.downcase.split.join("_"), html: "<div id='#{self.subject.downcase.split.join("_")}' class='scrolling-details'><h3>#{self.subject}</h3>#{self.displayed_content.body}</div>")
  end

  def caluculate_token_cost(model = DEFAULT_MODEL)
    Rails.logger.debug "model: #{model}"
    prices = OpenAiClient.get_model_prices(model)
    Rails.logger.debug "prices: #{prices}"
    Rails.logger.debug "self.completion_tokens_cost: #{self.completion_tokens_cost}"
    Rails.logger.debug "self.prompt_tokens_cost: #{self.prompt_tokens_cost}"
    total_output_cost = prices[:output] * (self.completion_tokens_cost / 1000)
    total_input_cost = prices[:input] * (self.prompt_tokens_cost / 1000)
    Rails.logger.debug "total_output_cost: #{total_output_cost}"
    Rails.logger.debug "total_input_cost: #{total_input_cost}"
    total_output_cost + total_input_cost
  end

  def update_token_stats!(response)
    Rails.logger.debug "Updating token stats for #{self.subject}"
    self.prompt_tokens_cost = response[:prompt_tokens]
    self.completion_tokens_cost = response[:completion_tokens]

    self.total_token_cost = caluculate_token_cost(response[:model])
    Rails.logger.debug "TOTAL TOKEN COST: #{self.total_token_cost}"
    self.save!
  end
end
