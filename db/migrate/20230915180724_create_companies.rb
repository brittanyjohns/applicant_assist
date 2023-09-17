class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :website
      t.string :industry
      t.string :location

      t.timestamps
    end
  end
end
