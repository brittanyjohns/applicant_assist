class CreateChats < ActiveRecord::Migration[7.1]
  def change
    remove_column :posts, :message_id, :integer
    remove_column :messages, :message_id, :string
    remove_column :messages, :user_id, :integer
    create_table :chats do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :source, polymorphic: true, null: false
      t.string :title

      t.timestamps
    end
    add_column :messages, :chat_id, :integer
    add_column :messages, :role, :string
    rename_column :messages, :body, :content
  end
end
