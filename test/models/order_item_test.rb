# == Schema Information
#
# Table name: order_items
#
#  id               :bigint           not null, primary key
#  coin_value       :integer          default(0)
#  quantity         :integer
#  total_coin_value :integer          default(0)
#  total_price      :decimal(, )
#  unit_price       :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  order_id         :bigint           not null
#  product_id       :bigint           not null
#
# Indexes
#
#  index_order_items_on_order_id    (order_id)
#  index_order_items_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (product_id => products.id)
#
require "test_helper"

class OrderItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
