class GmailController < ApplicationController
  before_action :authorize_gmail, only: [:search]

  def authorize_gmail
    client = Signet::OAuth2::Client.new(access_token: session[:access_token])

    service = Google::Apis::GmailV1::GmailService.new

    service.authorization = client
    @gmail = service
  end

  def gmail_client
    @gmail ||= authorize_gmail
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

    respond_to do |format|
      format.html { redirect_to root_url, notice: "Success! => #{session[:access_token]}" }
      format.json { head :no_content }
    end
  end

  def check_access_token
    unless user_credentials.access_token
      redirect main_redirect_url
    end
  end

  def user_credentials
    # Build a per-request oauth credential based on token stored in session
    # which allows us to use a shared API client.
    @authorization ||= (auth = gmail_client.authorization.dup
      auth.redirect_uri = callback_url
      auth.update_token!(session)
      auth)
  end

  def set_session_data
    session[:access_token] = user_credentials.access_token
    session[:refresh_token] = user_credentials.refresh_token
    session[:expires_in] = user_credentials.expires_in
    session[:issued_at] = user_credentials.issued_at
  end

  def search
    search_term = "from:*#{params[:query].downcase}"
    unread_only = params[:unread] == 1
    search_term += " is:unread" if unread_only
    puts "unread_only: #{unread_only}"
    @gmail_search_results = Message.search_and_save(gmail_client, current_user, search_term)
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
end
