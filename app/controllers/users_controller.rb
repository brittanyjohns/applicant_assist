class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy parse_resume_pdf ]

  def index
  end

  def show
  end

  def edit
  end

  def parse_resume_pdf
    @user.parse_and_save_resume if @user.uploaded_resume.attached?
    redirect_to user_url(@user), notice: "Resume parsed."
  end

  def update
    puts "doc_params: #{doc_params}"
    @user.uploaded_resume.attach(user_params[:uploaded_resume]) if user_params[:uploaded_resume]
    @user.docs.create(doc_type: "resume", displayed_content: doc_params[:displayed_content]) unless doc_params[:displayed_content].blank?

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
    params.require(:user).permit(:name, :uploaded_resume, doc: [:id, :displayed_content, :doc_type])
  end

  def doc_params
    user_params.require(:doc).permit(:id, :displayed_content, :doc_type)
  end
end
