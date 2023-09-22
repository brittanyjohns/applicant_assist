class ChatWithAiJob < ApplicationJob
  queue_as :default

  def perform(chat)
    puts "\n*** Running the Chat with AI job!!\n\n"
    chat.chat_with_ai!
  end
end
