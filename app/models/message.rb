class Message < ApplicationRecord
  has_rich_text :content
  after_save :save_content
  def self.save_email_message(gmail, email_message_id)
    result = gmail.get_user_message("me", email_message_id, format: "full")
    return unless result
    payload = result.payload
    headers = payload.headers if payload

    if headers
      date = headers.any? { |h| h.name == "Date" } ? headers.find { |h| h.name == "Date" }.value : ""
      from = headers.any? { |h| h.name == "From" } ? headers.find { |h| h.name == "From" }.value : ""
      to = headers.any? { |h| h.name == "To" } ? headers.find { |h| h.name == "To" }.value : ""
      subject = headers.any? { |h| h.name == "Subject" } ? headers.find { |h| h.name == "Subject" }.value : ""
    end
    body = payload.body.data
    # body = result.raw
    if body.nil? && payload&.parts&.any?
      body = payload.parts.map { |part| part.body.data }.join
    end
    new_msg = self.create(message_id: email_message_id, date_received: date, to: to, from: from, subject: subject, body: body)

    puts "id: #{result.id}"
    puts "date: #{date}"
    puts "from: #{from}"
    puts "to: #{to}"
    puts "subject: #{subject}"
    new_msg if new_msg.persisted?
  end

  def self.list_emails(gmail)
    messages = []
    next_page = nil
    limit = 10
    begin
      result = gmail.list_user_messages("me", max_results: limit, page_token: next_page)
      messages += result.messages
      break if messages.size >= limit
      next_page = result.next_page_token
    end while next_page
    puts "Returning #{messages.count} messages."
    messages
  end

  def self.search_and_save(gmail, query, limit = 5)
    ids =
      gmail.fetch_all(max: limit, items: :messages) do |token|
        gmail.list_user_messages("me", max_results: [limit, 500].min, q: query, page_token: token)
      end.map(&:id)

    puts "FOUND #{ids.count} emails"

    ids.each do |id|
      self.save_email_message(gmail, id)
    end
  end

  def save_content
    return unless body && id
    rich_text_content = ActionText::RichText.find_or_initialize_by(record_type: "Message", record_id: id, name: "content", body: body)
    rich_text_content.save!
  end
end
