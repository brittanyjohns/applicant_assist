class AddTokensSpentToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :total_gpt_tokens_spent, :decimal, default: 0
    add_column :users, :total_app_tokens_spent, :decimal, default: 0
    add_column :chats, :total_token_usd_cost, :decimal, default: 0
    add_column :messages, :prompt_tokens_cost, :decimal, default: 0
    add_column :messages, :completion_tokens_cost, :decimal, default: 0
    add_column :messages, :total_token_cost, :decimal, default: 0
    add_column :messages, :in_reply_to, :integer
  end
end
