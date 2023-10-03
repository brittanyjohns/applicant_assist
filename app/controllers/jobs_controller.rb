class JobsController < ApplicationController
  before_action :set_job, only: %i[ show edit update destroy get_details create_application ]
  before_action :ensure_details, only: %i[ show ]

  # GET /jobs or /jobs.json
  def index
    # @jobs = Job.includes(:company).order(created_at: :desc).limit(20)
    # @jobs = Job.order(:title).page params[:page]
    @jobs = Job.includes(:company).order(created_at: :desc).page params[:page]
  end

  # GET /jobs/1 or /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  def create_application
    @application = @job.applications.new(user: current_user)

    respond_to do |format|
      if @application.save
        @chat = Chat.create(source: @application, user: current_user)
        Rails.logger.debug "Jobs create_application - Chat created! ID: #{chat.id}"
        # ChatWithAiJob.perform_async(@chat.id)
        format.html { redirect_to @application, notice: "Application was successfully updated." }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /jobs or /jobs.json
  def create
    @job = Job.new(job_params)
    if !job_params[:company_id]
      @job.company = Company.find_or_create_by(name: job_params[:company_name])
    else
      @job.company = Company.find(job_params[:company_id])
    end

    respond_to do |format|
      if @job.save
        format.html { redirect_to job_url(@job), notice: "Job was successfully created." }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1 or /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to job_url(@job), notice: "Job was successfully updated." }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1 or /jobs/1.json
  def destroy
    @job.destroy!

    respond_to do |format|
      format.html { redirect_to jobs_url, notice: "Job was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def search
    search_term = params[:job_search][:q]
    respond_to do |format|
      Indeed.new(search_term).search
      # jid = JobSearchJob.perform_async(search_term)
      format.html { redirect_to jobs_url, notice: "Jobs loaded -- " }
      format.json { head :no_content }
    end
  end

  def get_details
    jid = JobDetailsJob.perform_async(@job.web_id) unless @job.has_all_details?

    respond_to do |format|
      format.html { redirect_to job_url(@job), notice: "#{jid ? "Adding some more details..." : "Details already loaded."}" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_job
    @job = Job.includes(:company).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def job_params
    params.require(:job).permit(:company_id, :company_name, :title, :description, :location, :salary, :job_type, :experience, :favorite, :rating, :status)
  end

  def ensure_details
  end
end
