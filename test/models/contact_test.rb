# == Schema Information
#
# Table name: contacts
#
#  id           :bigint           not null, primary key
#  company_name :string
#  email        :string
#  job_title    :string
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "test_helper"

class ContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
