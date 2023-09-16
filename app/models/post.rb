# == Schema Information
#
# Table name: posts
#
#  id              :bigint           not null, primary key
#  author_type     :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  author_id       :bigint           not null
#  conversation_id :bigint           not null
#  message_id      :string
#
# Indexes
#
#  index_posts_on_author           (author_type,author_id)
#  index_posts_on_conversation_id  (conversation_id)
#
# Foreign Keys
#
#  fk_rails_...  (conversation_id => conversations.id)
#
class Post < ApplicationRecord
  belongs_to :conversation
  belongs_to :author, polymorphic: true
  has_rich_text :body
  broadcasts_to :conversation, target: "posts"

  # before_create :ensure_conversation

  def ensure_conversation(user_id)
    self.conversation = Conversation.create!(subject: "Auto Generated")
  end
end
