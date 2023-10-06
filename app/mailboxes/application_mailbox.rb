class ApplicationMailbox < ActionMailbox::Base
  before_processing :ensure_sender_is_a_user

  # conversation-12345@example.com -> ReplyMailbox
  routing ReplyMailbox::MATCHER => :reply
  # support@example.com -> ConversationMailbox

  routing User::MATCHER => :user

  routing :all => :conversation

  def from
    @from ||= mail.from_address
  end

  def author
    # user = User.find_by(email: from.address)
    user || contact
  end

  def contact
    @contact ||= Contact.where(email: from.address).first_or_initialize
    if @contact.name.blank?
      @contact.name = from.display_name unless from.display_name.blank?
    end
    @contact.save!
    @contact
  end

  def user
    @user ||= User.find_by(username: username)
  end

  def username
    mail.recipients.find { |recipient| User::MATCHER.match?(recipient) }[User::MATCHER, 1]
  end

  def body
    if mail.multipart? && mail.html_part
      puts "multi part - html"
      mail.html_part.body.decoded
    elsif mail.multipart? && mail.text_part
      puts "multi part - text"
      mail.text_part.decoded
    else
      puts "single part"
      mail.decoded
    end
    # mail.body.parts[1].body.decoded
  end

  def conversation
    puts "finding or creating conversation by contact_id: #{contact.id} and subject: #{mail.subject}"
    @conversation ||= user.conversations.find_or_create_by(contact_id: contact.id, subject: mail.subject)
  end

  def ensure_sender_is_a_user
    puts "\nSTART INBOUND MAIL:\n"
    puts "to: #{mail.to}"
    puts "from: #{mail.from}"
    puts "recipients: #{mail.recipients}"
    puts "message_id: #{mail.message_id}"
    puts "subject: #{mail.subject}"
    puts "\n\nnot decoded body: #{mail.body.parts[1].body}\n\n"
    puts "\n\ndecoded body: #{mail.body.parts[1].body.decoded}\n\n"
    puts "\nEND INBOUND MAIL:\n"
    if user
      puts "USER FOUND: #{username}"
    else
      puts "USER NOT FOUND"
    end
  end
end
