# == Schema Information
#
# Table name: products
#
#  id                  :bigint           not null, primary key
#  active              :boolean
#  coin_value          :integer          default(0)
#  description         :text
#  name                :string
#  price               :decimal(, )
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  product_category_id :bigint           not null
#
# Indexes
#
#  index_products_on_product_category_id  (product_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_category_id => product_categories.id)
#
require "test_helper"

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
