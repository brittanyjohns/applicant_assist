# Preview all emails at http://localhost:3000/rails/mailers/conversation_mailer
class ConversationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/conversation_mailer/new_post
  def new_post
    post = Post.last
    conversation = post.conversation
    puts "conversation: #{conversation.id}"
    ConversationMailer.with(
      to: "no-reply@example.com",
      post: post,
      conversation: conversation
    ).new_post
  end

end
