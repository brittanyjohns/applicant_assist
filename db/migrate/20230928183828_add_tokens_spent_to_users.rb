class AddTokensSpentToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :total_gpt_tokens_spent, :integer, default: 0
    add_column :users, :total_app_tokens_spent, :integer, default: 0
    add_column :chats, :total_token_cost, :integer, default: 0
    add_column :messages, :prompt_token_cost, :integer, default: 0
    add_column :messages, :completion_token_cost, :integer, default: 0
    add_column :messages, :total_token_cost, :integer, default: 0
    add_column :messages, :in_reply_to, :integer
  end
end
