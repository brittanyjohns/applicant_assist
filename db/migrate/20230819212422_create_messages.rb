class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :date_received
      t.string :from
      t.string :message_id
      t.string :to
      t.string :subject
      t.text :body
      t.integer :user_id

      t.timestamps
    end
  end
end
