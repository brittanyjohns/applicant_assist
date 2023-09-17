# == Schema Information
#
# Table name: jobs
#
#  id          :bigint           not null, primary key
#  description :text
#  experience  :text
#  job_source  :string
#  job_type    :string
#  location    :string
#  salary      :string
#  status      :integer          default("active")
#  title       :string
#  web_link    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :bigint           not null
#  web_id      :string
#
# Indexes
#
#  index_jobs_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Job < ApplicationRecord
  belongs_to :company
  has_many :applications
  has_many :users, through: :applications
  attr_accessor :company_name

  enum :status, { active: 0, inactive: 1 }
end
