class ChatWithAiJob < ApplicationJob
  queue_as :default

  def perform(chat)
    chat.chat_with_ai!
  end
end
