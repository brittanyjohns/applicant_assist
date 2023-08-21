class MainController < ApplicationController
  before_action :authorize_gmail, only: [:labels]

  def index
    @messages = Message.all
  end

  def redirect
    puts "url: #{callback_url}"
    client = Signet::OAuth2::Client.new({
      client_id: ENV.fetch("GOOGLE_API_CLIENT_ID"),
      client_secret: ENV.fetch("GOOGLE_API_CLIENT_SECRET"),
      authorization_uri: "https://accounts.google.com/o/oauth2/auth",
      scope: Google::Apis::GmailV1::AUTH_GMAIL_READONLY,
      redirect_uri: callback_url,
    })

    redirect_to client.authorization_uri.to_s, allow_other_host: true
  end

  def callback
    puts "callback: #{ENV.fetch("GOOGLE_API_CLIENT_ID")}"
    client = Signet::OAuth2::Client.new({
      client_id: ENV.fetch("GOOGLE_API_CLIENT_ID"),
      client_secret: ENV.fetch("GOOGLE_API_CLIENT_SECRET"),
      token_credential_uri: "https://accounts.google.com/o/oauth2/token",
      redirect_uri: callback_url,
      code: params[:code],
    })

    response = client.fetch_access_token!

    session[:access_token] = response["access_token"]

    redirect_to url_for(:action => :labels)
  end

  def labels
    search_term = "ConvertKit"
    # messages = Message.list_emails(@gmail)
    results = Message.search_and_save(@gmail, search_term)

    @labels_list = results
    # messages.each do |message|
    #   Message.save_email_message(@gmail, message.id)
    # end

    puts "Found #{results.size} messages matching #{search_term}"
  end
end
