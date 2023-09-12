class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.boolean :active
      t.belongs_to :product_category, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
