# == Schema Information
#
# Table name: chats
#
#  id          :bigint           not null, primary key
#  source_type :string           not null
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  source_id   :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_chats_on_source   (source_type,source_id)
#  index_chats_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true
  has_many :messages
  after_create_commit { broadcast_append_to("chats") }

  def format_messages
    if messages.blank?
      [messages.create!(role: "system", content: "You are a funny and sarcastic, but also very helpful, assistant.")]
    else
      messages.map do |msg|
        { role: msg.role, content: msg.content }
      end
    end
  end

  def prompt
    messages.last&.content || title || "Hello there AI dude."
  end

  def open_ai_opts
    { prompt: prompt, messages: format_messages }
  end

  def chat_with_ai!
    response = OpenAiClient.new(open_ai_opts).create_chat
    puts "Totals response: #{response.inspect}\n\n"
    if response
      role = response[:role]
      content = response[:content]

      self.save!

      new_line_regex = /\n/
      msg = messages.new(role: role, content: content)
      new_line_regex = /\n/
      replaced_text = content.gsub(new_line_regex, "<br>") if content

      puts replaced_text
      msg.displayed_content.body = replaced_text

      msg.save!
    else
      puts "**** ERROR **** \nDid not receive valid response.\n"
    end
    self
  end
end
