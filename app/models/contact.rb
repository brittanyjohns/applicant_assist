# == Schema Information
#
# Table name: contacts
#
#  id             :bigint           not null, primary key
#  company_name   :string
#  email          :string
#  job_title      :string
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  application_id :integer
#
class Contact < ApplicationRecord
  has_one_attached :avatar

  has_many :conversations
  has_many :posts, as: :author
  belongs_to :application, optional: true
  after_create_commit { broadcast_append_to("contacts") }
  scope :active_contacts, -> { joins(:application).merge(Application.with_active_job) }
end
