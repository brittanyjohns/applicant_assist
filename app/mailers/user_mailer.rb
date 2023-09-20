class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_email.subject
  #
  def welcome_email(user)
    # mail(to: params[:user].email,
    #      body: params[:email_body],
    #      content_type: "text/html",
    #      subject: "Already rendered!")
    @user = user
    @url = root_url
    # delivery_options = { user_name: params[:company].smtp_user,
    #                      password: params[:company].smtp_password,
    #                      address: params[:company].smtp_host }
    @sending_to = @user.email
    mail(to: @sending_to,
         subject: "WELCOME!!!!")
  end
end
