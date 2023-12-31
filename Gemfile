source "https://rubygems.org"

ruby "3.2.2"

# Use main development branch of Rails
gem "rails", github: "rails/rails", branch: "main"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

gem "hotwire-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

gem "nokogiri"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "gobject-introspection", "~> 4.1"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"
# PDF Processing
gem "poppler"
# NOTE - After adding poppler I had to install the following packages manually before I could deploy to prod via Hatchbox
# sudo apt-get install -V -y libpoppler-glib-dev
# sudo apt-get install -V -y libgirepository1.0-dev

# AWS - ActiveStorage in production
gem "aws-sdk-s3", require: false

gem "ruby-openai", "~> 5.1"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  gem "ruby-lsp-rails"
end

group :development do
  gem "erb-formatter"
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem "annotate"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end

gem "devise", "~> 4.9"

gem "google-api-client", "~> 0.9", require: "google/apis/gmail_v1"
# Config & ENV vars
gem "figaro"
gem "bootstrap", "~> 5.3.1"
gem "simple_form"
gem "braintree", "~> 4.5"

gem "sidekiq", "~> 7.1"

gem "jsbundling-rails", "~> 1.2"

gem "httparty", "~> 0.21.0"
gem "postmark-rails"
# Pagination
gem "kaminari"
