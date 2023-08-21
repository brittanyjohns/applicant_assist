class ApplicationController < ActionController::Base
  def authorize_gmail
    client = Signet::OAuth2::Client.new(access_token: session[:access_token])

    service = Google::Apis::GmailV1::GmailService.new

    service.authorization = client
    @gmail = service
  end
end
