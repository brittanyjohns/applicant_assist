class UsersController < ApplicationController
  def index
  end

  def show
  end

  def welcome_email
    mail = UserMailer.welcome_email(current_user).deliver_later
    redirect_to root_url, notice: "Mail sent --- #{mail.inspect} "
  end
end
