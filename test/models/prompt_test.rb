# == Schema Information
#
# Table name: prompts
#
#  id         :bigint           not null, primary key
#  active     :boolean
#  body       :text
#  subject    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class PromptTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
