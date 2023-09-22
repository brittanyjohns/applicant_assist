class ChatsController < ApplicationController
  before_action :set_chat, only: %i[ show edit update destroy message_prompt ]
  before_action :set_application, only: %i[ create ]
  # GET /chats or /chats.json
  def index
    @chats = Chat.all
  end

  # GET /chats/1 or /chats/1.json
  def show
    @message = @chat.messages.new
    @messages = @chat.messages_to_display
  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit
  end

  # POST /chats or /chats.json
  def create
    @chat = Chat.new(chat_params)
    @chat.user = current_user
    @chat.source = @application

    respond_to do |format|
      if @chat.save
        ChatWithAiJob.perform_now(@chat)
        format.html { redirect_to chat_url(@chat), notice: "Chat was successfully created." }
        format.json { render :show, status: :created, location: @chat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  def message_prompt
    prompt_type = params["commit"]
    message = @chat.messages.new(role: "user", subject: prompt_type)
    message.setup_prompt(prompt_type)
    puts "Saving MESAGE: #{message.inspect}"
    respond_to do |format|
      if message.save
        ChatWithAiJob.perform_now(@chat)
        format.html { redirect_to application_url(@chat.source.id) }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chats/1 or /chats/1.json
  def update
    respond_to do |format|
      if @chat.update(chat_params)
        format.html { redirect_to chat_url(@chat), notice: "Chat was successfully updated." }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1 or /chats/1.json
  def destroy
    @chat.destroy!

    respond_to do |format|
      format.html { redirect_to chats_url, notice: "Chat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chat
    @chat = Chat.find(params[:id])
  end

  def set_application
    @application = Application.find(params[:application_id])
  end

  # Only allow a list of trusted parameters through.
  def chat_params
    params.require(:chat).permit(:user_id, :source_id, :source_type, :title)
  end
end
