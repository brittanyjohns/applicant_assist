# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  coins                  :integer          default(0)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  MATCHER = /^(\S+)@/i
  has_many :messages
  has_many :orders
  has_many :posts, as: :author
  has_many :applications
  has_many :conversations
  has_many :jobs, through: :applications
  has_many :companies, through: :jobs
  has_many :docs, as: :documentable
  # has_one_attached :resume
  # has_many :contacts, through: :applications
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  accepts_nested_attributes_for :docs

  # validates :username, uniqueness: true

  before_save :set_username

  def resume
    docs.where(doc_type: "resume").first
  end

  def set_username
    t = email[User::MATCHER, 1]
    if User::MATCHER.match?(email)
      self.username = email[User::MATCHER, 1]
    end
  end

  def internal_email
    "#{username}@applicant-assist.com"
  end

  def applied_for(job_id)
    self.job_ids.uniq.include?(job_id)
  end

  def jobs_not_applied_to
    Job.includes(:company).where.not(id: self.job_ids.uniq)
  end

  def display_name
    name || username
  end

  def saved_resume
    return unless resume.attached?
    get_attachment_url(resume)
    # Rails.application.routes.url_helpers.rails_blob_path(resume, only_path: true)
  end

  def get_attachment_url(attachment_type)
    puts "IN TEST & DEV: #{ActiveStorage::Blob.service.path_for(attachment_type.key)}"
    puts "IN PROD: #{Rails.application.routes.url_helpers.rails_blob_url(attachment_type)}"
    if Rails.env.test? || Rails.env.development?
      return ActiveStorage::Blob.service.path_for(attachment_type.key)
    end
    Rails.application.routes.url_helpers.rails_blob_url(attachment_type)
  end

  def parse_resume
    return unless resume.attached?
    document = Poppler::Document.new(saved_resume)
    parse_resume = document.map { |page| page.get_text }.join
    File.open("parse_resume.txt", "w") { |f| f.write "#{Time.now} - parse_resume\n#{parse_resume}\n" }
  end
end
