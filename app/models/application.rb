# == Schema Information
#
# Table name: applications
#
#  id           :bigint           not null, primary key
#  applied_at   :datetime
#  archived_at  :datetime
#  company_link :string
#  details      :text
#  favorite     :boolean          default(FALSE)
#  job_link     :string
#  job_source   :string
#  notes        :text
#  rating       :integer          default(0)
#  stage        :integer          default("initial")
#  status       :integer          default("draft")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  job_id       :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_applications_on_job_id   (job_id)
#  index_applications_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (user_id => users.id)
#
class Application < ApplicationRecord
  belongs_to :user
  belongs_to :job
  has_many :posts, as: :author, dependent: :destroy
  has_many :chats, as: :source, dependent: :destroy
  scope :with_active_job, -> { joins(:job).merge(Job.active) }

  enum :status, { draft: 0, applied: 1, in_progress: 2, accepted: 3, rejected: 4, on_hold: 5 }
  enum :stage, { initial: 0, screening: 1, interviewing: 2, negotiating: 3, passing: 4, starting: 5 }

  def company_name
    job.company_name
  end

  def initial_chat
    chats.first
  end

  def additional_chats
    chats.where.not(id: initial_chat.id)
  end
end
