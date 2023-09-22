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
    self.role = "user" if self.role.blank?
  end

  def save_rich_content
    if content
      puts "setting display text"
      # new_line_regex = /\n/
      # replaced_text = content.gsub(new_line_regex, "<br>")

      # puts replaced_text
      self.displayed_content.body = content
    end
  end

  def missing_content
    displayed_content.nil? || displayed_content.body.blank?
    true
  end

  def setup_prompt(prompt_type)
    case prompt_type
    when "Interview Tips"
      # ask_for_interview_tips
      self.role = "user"
      self.content = build_interview_tips_prompt
      self.subject = prompt_type
    when "Company Info"
      # ask_for_company_info
      self.role = "user"
      self.content = build_company_info_prompt
      self.subject = prompt_type
    else
      puts "NO PROMPT FOR '#{prompt_type}' YET"
      # "Doing something else"
    end
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
    " Provide as much detail as possible. I understand you are an AI language model with limitations, so any company information you have available will work."
  end

  def bootstrap_styling
    "styled using Bootstrap css helpers"
  end

  def company_info_table_id
    "company_#{chat.source.job.company.id}"
  end

  def interview_tips_table_id
    "interview_tips_for_job_#{chat.source.job.id}"
  end

  def build_interview_tips_prompt
    "Give me 3 interview tips for applying to a job with the following job posting:\n#{job_posting}\n #{detailed_response} Please format the response as a HTML table. Only include html table with the id of #{interview_tips_table_id} , class name of interview_tips_table, and #{bootstrap_styling} in the response. "
  end

  def build_company_info_prompt
    "Tell me 3 things that would be helpful for someone applying to #{company_name} as a #{job_title} to know about the company. #{detailed_response} Please format the response as a HTML table. Only include html table with the id of #{company_info_table_id} , class name of company_info_table, and #{bootstrap_styling} in the response."
  end
end
