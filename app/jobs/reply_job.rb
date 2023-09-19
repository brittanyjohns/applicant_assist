class ReplyJob < ApplicationJob
  queue_as :default
  attr_reader :post

  def perform(*args)
    puts "args #{args}"
    @post = args[0]
    # @post = args[:post]
    return if post.message_id?

    mail = ConversationMailer.with(
      to: "bhannajohns@gmail.com",
      reply_to: " conversation-#{post.conversation_id}@example.com",
      bcc: recipients.map { |r| "#{r.name} <#{r.email}>" },
      post: post,
      conversation: conversation,
      in_reply_to: previous_message_ids.last,
      references: previous_message_ids,
    ).new_post.deliver_now

    post.update!(message_id: mail.message_id)
  end

  def conversation
    @conversation ||= post.conversation
  end

  def recipients
    @recipients ||= conversation.authors - [post.author]
  end

  def previous_message_ids
    @previous_message_ids ||= conversation.posts.where.not(id: post.id).pluck(:message_id).compact
  end
end
