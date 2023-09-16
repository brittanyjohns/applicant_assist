# == Schema Information
#
# Table name: applications
#
#  id           :bigint           not null, primary key
#  applied_at   :datetime
#  archived_at  :datetime
#  company_link :string
#  details      :text
#  favorite     :boolean
#  job_link     :string
#  job_source   :string
#  notes        :text
#  rating       :integer
#  stage        :integer
#  status       :integer
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
require "test_helper"

class ApplicationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
