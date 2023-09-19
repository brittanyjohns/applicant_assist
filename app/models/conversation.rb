# == Schema Information
#
# Table name: conversations
#
#  id         :bigint           not null, primary key
#  subject    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  contact_id :bigint
#  user_id    :integer
#
# Indexes
#
#  index_conversations_on_contact_id  (contact_id)
#
# Foreign Keys
#
#  fk_rails_...  (contact_id => contacts.id)
#
class Conversation < ApplicationRecord
  belongs_to :contact, optional: true
  belongs_to :user, optional: true
  has_many :posts, dependent: :destroy

  after_create_commit { broadcast_append_to("conversations") }

  def authors
    posts.includes(:author).map(&:author).uniq
  end
end
