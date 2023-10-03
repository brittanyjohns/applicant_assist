class UserMailbox < ApplicationMailbox
  def process
    # conversation = user.conversations.create(subject: mail.subject, contact: contact)
    # conversation = @conversation
    puts "\nUSER conversation: #{conversation.inspect}"
    puts "\n\nMAIL: #{mail.inspect}\n"
    conversation.posts.create(
      author: contact,
      body: body,
      email_message_id: mail.message_id,
    )
  end
end
