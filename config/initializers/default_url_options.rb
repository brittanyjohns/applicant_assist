hosts = {
  development: "localhost",
  test: "localhost",
  production: "applicant-assist.com",
}.freeze

Rails.application.routes.default_url_options[:host] = hosts[Rails.env.to_sym]
