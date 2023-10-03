class AddMessageIdToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :email_message_id, :string
  end
end
