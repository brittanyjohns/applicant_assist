class AddTokensToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :coins, :integer, default: 0
    add_column :products, :coin_value, :integer, default: 0
    add_column :orders, :total_coin_value, :integer, default: 0
    add_column :order_items, :total_coin_value, :integer, default: 0
    add_column :order_items, :coin_value, :integer, default: 0
  end
end
