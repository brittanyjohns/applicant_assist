class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.decimal :subtotal
      t.decimal :tax
      t.decimal :shipping
      t.decimal :total
      t.integer :order_status_id
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
