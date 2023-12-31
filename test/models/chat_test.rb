# == Schema Information
#
# Table name: chats
#
#  id                   :bigint           not null, primary key
#  source_type          :string           not null
#  title                :string
#  total_token_usd_cost :decimal(, )      default(0.0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  source_id            :bigint           not null
#  user_id              :bigint           not null
#
# Indexes
#
#  index_chats_on_source   (source_type,source_id)
#  index_chats_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class ChatTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
