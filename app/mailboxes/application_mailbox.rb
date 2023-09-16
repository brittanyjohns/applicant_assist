class ApplicationMailbox < ActionMailbox::Base
  # conversation-12345@example.com -> ReplyMailbox
  routing ReplyMailbox::MATCHER => :reply
  # support@example.com -> ConversationMailbox

  routing :all => :conversation

  def from
    @from ||= mail.from_address
  end

  def author
    user = User.find_by(email: from.address)
    user || contact
  end

  def contact
    contact = Contact.where(email: from.address).first_or_initialize
    contact.update(name: from.display_name) unless from.display_name.blank?
    contact
  end

  def body
    if mail.multipart? && mail.html_part
      mail.html_part.body.decoded
    elsif mail.multipart? && mail.text_part
      mail.text_part.decoded
    else
      mail.decoded
    end
  end
end
