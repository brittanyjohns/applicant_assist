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
require "test_helper"

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
