class ChatWithAiJob
  include Sidekiq::Job
  queue_as :default

  def perform(chat_id)
    puts "\n*** Running the Chat with AI job!! CHAT ID: #{chat_id}\n"
    chat = Chat.find(chat_id)
    response = chat.chat_with_ai!
    puts "RESPONSE from Job: #{response.inspect}"
    if response.nil?
      raise "No response from OpenAI"
    end
  end
end
