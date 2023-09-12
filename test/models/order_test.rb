# == Schema Information
#
# Table name: orders
#
#  id               :bigint           not null, primary key
#  shipping         :decimal(, )
#  status           :integer          default("in_progress")
#  subtotal         :decimal(, )
#  tax              :decimal(, )
#  total            :decimal(, )
#  total_coin_value :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
