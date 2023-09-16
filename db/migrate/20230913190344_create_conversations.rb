class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations do |t|
      t.string :subject
      t.belongs_to :contact, null: true, foreign_key: true

      t.timestamps
    end
  end
end
