class ApplicationsController < ApplicationController
  before_action :set_application, only: %i[ show edit update destroy ]
  before_action :set_job, only: %i[ create create_chat ]

  # GET /applications or /applications.json
  def index
    @applications = current_user.applications.includes(:job).order(created_at: :desc)
  end

  # GET /applications/1 or /applications/1.json
  def show
    @chat = Chat.new(source: @application, user: current_user)
    @app_messages_to_display = @app_chat.messages.display_to_user
  end

  # GET /applications/new
  def new
    @job = Job.find(params[:job_id])
    @application = Application.new
    @application.user = current_user
  end

  # GET /applications/1/edit
  def edit
  end

  def create_chat
    @chat = Chat.create(source: @application, user: @application.user)

    respond_to do |format|
      if @chat.persisted?
        puts "App create_chat - Chat created! ID: #{chat.id}"
        # ChatWithAiJob.perform_async(@chat.id)
        format.html { redirect_to chat_url(@chat), notice: "Chat was successfully created." }
        format.json { render :show, status: :created, location: @chat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /applications or /applications.json
  def create
    puts "Creating an application! PARAMS: #{application_params}"
    @application = Application.new(application_params)
    @application.user = current_user

    respond_to do |format|
      if @application.save
        @chat = Chat.create(source: @application, user: @application.user)
        @chat.chat_with_ai!
        format.html { redirect_to application_url(@application), notice: "Application was successfully created." }
        format.json { render :show, status: :created, location: @application }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /applications/1 or /applications/1.json
  def update
    respond_to do |format|
      if @application.update(application_params)
        format.html { redirect_to application_url(@application), notice: "Application was successfully updated." }
        format.json { render :show, status: :ok, location: @application }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applications/1 or /applications/1.json
  def destroy
    @application.destroy!

    respond_to do |format|
      format.html { redirect_to applications_url, notice: "Application was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_application
    @application = Application.includes(:chats).find(params[:id])
    @app_chat = @application.initial_chat
  end

  def set_job
    @job = Job.find(application_params[:job_id])
  end

  # Only allow a list of trusted parameters through.
  def application_params
    params.require(:application).permit(:user_id, :job_id, :status, :stage, :applied_at, :archived_at, :job_source, :job_link, :company_link, :favorite, :rating, :details, :notes)
  end
end
