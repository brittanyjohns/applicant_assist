# == Schema Information
#
# Table name: messages
#
#  id                     :bigint           not null, primary key
#  completion_tokens_cost :decimal(, )      default(0.0)
#  content                :text
#  date_received          :string
#  from                   :string
#  in_reply_to            :integer
#  prompt_tokens_cost     :decimal(, )      default(0.0)
#  role                   :string
#  subject                :string
#  to                     :string
#  total_token_cost       :decimal(, )      default(0.0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  chat_id                :integer
#
require "test_helper"

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
