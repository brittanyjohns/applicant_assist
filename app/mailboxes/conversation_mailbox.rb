class ConversationMailbox < ApplicationMailbox
  def process
    conversation = Conversation.create(subject: mail.subject, contact: contact)
    conversation.posts.create!(
      author: contact,
      body: body,
      email_message_id: mail.message_id,
    )
  end
end
