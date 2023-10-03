Sidekiq.configure_server do |config|
  logger = ActiveSupport::Logger.new("log/sidekiq_#{Rails.env}.log")
  logger.formatter = config.log_formatter
  config.logger = ActiveSupport::TaggedLogging.new(logger)
  config.log_level = :debug
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end
