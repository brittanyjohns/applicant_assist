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
  attr_accessor :resume_sent
  has_rich_text :displayed_content
  belongs_to :chat
  validates :role, presence: true
  before_save :ensure_role
  broadcasts_to :chat, target: "messages"

  def ensure_role
    self.role = "user" if self.role.blank?
  end

  def setup_prompt(prompt_type)
    self.role = "user"
    self.subject = prompt_type
    case prompt_type
    when "Interview Tips"
      # ask_for_interview_tips
      self.content = build_interview_tips_prompt
    when "Company Info"
      # ask_for_company_info
      self.content = build_company_info_prompt
    when "Resume Re-Write"
      self.content = build_resume_rewrite_prompt
    when "Resume Intro"
      self.content = build_resume_intro_prompt
    when "Elevator Speech"
      self.content = build_elevator_speech_prompt
    else
      puts "NO PROMPT FOR '#{prompt_type}' YET"
      # "Doing nothing for now"
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
    " styled using Bootstrap css helpers"
  end

  def company_info_table_id
    "company_#{chat.source.job.company.id}"
  end

  def interview_tips_table_id
    "interview_tips_for_job_#{chat.source.job.id}"
  end

  def build_resume_rewrite_prompt
    "Please rewrite the following resume, highlighting things that align with what this job posting is looking for. Please format as rich text. "
  end

  def build_resume_intro_prompt
    "Please write an awesome resume introduction that will help land an interview for this job. Use my current resume & job posting for details. "
  end

  def build_interview_tips_prompt
    "Give me 3 interview tips for applying to this job.\n #{detailed_response} #{formatted_as_table(interview_tips_table_id)}"
  end

  def build_company_info_prompt
    "Tell me 3 things that would be helpful for someone applying to #{company_name} as a #{job_title} to know about the company. Include things like mission statement, culture, industry, short summary of what they do, office locations (if applicable) & any other useful information. #{detailed_response}"
  end

  def build_elevator_speech_prompt
    "Write me a elevator speech as if I was talking directly to the hiring manager of this job. Keep it short, whiity & light - yet professional & direct. Highlight past experience from my resume if applicable to this job."
  end

  def build_initial_setup_prompt
  end

  def self.create_initial_setup_prompts_for(chat_id)
    sys_msg = create(chat_id: chat_id,
                     role: "system",
                     subject: "System Setup",
                     content: "You are a funny and whitty, but also very helpful, job search assistant.")
    sys_msg = create(chat_id: chat_id,
                     role: "user",
                     subject: "User Setup",
                     content: "You will help me get at the job described in the following job posting:\n #{job_posting}\nAnd here's my resume for future reference:\n #{chat.user_resume}")
  end

  def formatted_as_table(table_id)
    "Please format the response as a HTML table. Only include html table with the id of #{table_id} and #{bootstrap_styling} in the response."
  end
end
