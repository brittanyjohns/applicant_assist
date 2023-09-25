class ChatWithAiJob
  include Sidekiq::Job
  queue_as :default

  def perform(chat_id)
    puts "\n*** Running the Chat with AI job!! CHAT ID: #{chat_id}\n"
    chat = Chat.find(chat_id)
    chat.chat_with_ai!
  end
end
