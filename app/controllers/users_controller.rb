class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
  end

  def show
  end

  def edit
  end

  def update
    @user.resume.attach(user_params[:resume]) if user_params[:resume]

    respond_to do |format|
      if @user.update(name: user_params[:name])
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def welcome_email
    # Temp mailer test - placeholder
    mail = UserMailer.welcome_email(current_user).deliver_later
    redirect_to root_url, notice: "Mail sent --- #{mail.inspect} "
  end

  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to root_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.includes(:applications).find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, docs: [:id, :displayed_content, :doc_type])
  end
end
