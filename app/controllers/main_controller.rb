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
    client = Signet::OAuth2::Client.new({
      client_id: ENV.fetch("GOOGLE_API_CLIENT_ID"),
      client_secret: ENV.fetch("GOOGLE_API_CLIENT_SECRET"),
      token_credential_uri: "https://accounts.google.com/o/oauth2/token",
      redirect_uri: callback_url,
      code: params[:code],
    })

    response = client.fetch_access_token!

    session[:access_token] = response["access_token"]
    puts "session[:access_token]: #{session[:access_token]}"

    respond_to do |format|
      format.html { redirect_to root_url, notice: "Success! => #{session[:access_token]}" }
      format.json { head :no_content }
    end
  end
end
