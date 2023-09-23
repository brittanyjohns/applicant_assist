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
  # has_many :contacts, through: :applications
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # validates :username, uniqueness: true

  before_save :set_username

  def set_username
    t = email[User::MATCHER, 1]
    puts "email[User::MATCHER, 1]: #{t}"
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
end
