require "csv"

# == Schema Information
#
# Table name: posts
#
#  id               :bigint           not null, primary key
#  author_type      :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  author_id        :bigint           not null
#  conversation_id  :bigint           not null
#  email_message_id :string
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

  def process_inbound_email
    puts "Processing inbound email..."
    html_content = body.body.to_s

    puts "html_content: #{html_content}"
    # html_content = strip_html
    parsed_data = Nokogiri::HTML.parse(body.body.to_html)
    # links = parsed_data.search("a")
    # pp links
    parsed_data
  end

  def parse_html_5
    doc = Nokogiri.HTML5(body.body.to_html)
    links = doc.search("a")

    # Traverse the document
    doc.traverse do |node|
      next unless node.is_a?(Nokogiri::XML::Element) && node.name == "a"
      puts "node.name: #{node.name}"
      # puts "keys: node.keys: #{node.inspect}"
      puts "node href: #{node["href"]}"
      # ...
    end
    links
  end

  def get_job_id_from_email
    doc = Nokogiri.HTML5(body.body.to_html)
    links = doc.search("a")
    job_web_id = nil
    links.each do |link|
      puts "link: #{link}"
      next unless link["href"].include?("iaUid=")
      match = link["href"].match(/iaUid=([^&]*)/)
      puts "match: #{match}"
      job_web_id = match[1]
      break if match
    end
    job_web_id
  end

  def strip_html
    ActionView::Base.full_sanitizer.sanitize(body.body.to_s)
  end

  def print_table
    process_inbound_email.at("table").search("tr").each do |row|
      cells = row.search("th, td").map { |cell| cell.text.strip }

      puts CSV.generate_line(cells)
    end
  end

  def traverse_elements
    tags = Hash.new(0)

    process_inbound_email.traverse do |node|
      next unless node.is_a?(Nokogiri::XML::Element)
      puts "node.name: #{node.name}"
      puts "keys: node.keys: #{node.keys}"
      puts "node href: #{node["href"]}"
      tags[node.name] += 1
    end
    puts "tags: #{tags}"
    tags
  end
end
