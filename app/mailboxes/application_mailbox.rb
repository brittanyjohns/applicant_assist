class ApplicationMailbox < ActionMailbox::Base
  # routing /something/i => :somewhere

  # conversation-12345@example.com -> ReplyMailbox
  # support@example.com -> ConversationMailbox

  # routing :all => :conversations
end
