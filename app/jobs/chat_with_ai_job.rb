class ChatWithAiJob
  include Sidekiq::Job
  sidekiq_options queue: "default", retry: 2, backtrace: true
  # queue_as :default

  def perform(chat_id)
    Rails.logger.debug "\n*** Running the Chat with AI job!! CHAT ID: #{chat_id}\n"
    begin
      chat = Chat.find(chat_id)
      response = chat.chat_with_ai!
      Rails.logger.debug "RESPONSE from Job: #{response.inspect}"
      if response.nil?
        raise "No response from OpenAI"
      end
    rescue => e
      Rails.logger.debug "ERROR: #{e.message}"
      Rails.logger.debug e.backtrace
    end
  end
end
