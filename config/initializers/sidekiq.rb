Sidekiq.configure_server do |config|
  #   config.logger = Sidekiq::Logger.new($stdout)
  config.logger = Rails.logger
end
