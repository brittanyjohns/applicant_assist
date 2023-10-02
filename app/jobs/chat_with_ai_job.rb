class ChatWithAiJob
  include Sidekiq::Job
  sidekiq_options queue: "default", retry: 5
  # queue_as :default

  def perform(chat_id)
    puts "\n*** Running the Chat with AI job!! CHAT ID: #{chat_id}\n"
    begin
      chat = Chat.find(chat_id)
      response = chat.chat_with_ai!
      puts "RESPONSE from Job: #{response.inspect}"
      if response.nil?
        raise "No response from OpenAI"
      end
    rescue => e
      puts "ERROR: #{e.message}"
      puts e.backtrace
    end
  end
end
