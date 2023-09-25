class DocsController < ApplicationController
  before_action :set_doc, only: %i[ show edit update destroy ]
  include ActiveStorage::SetCurrent

  # GET /docs or /docs.json
  def index
    @docs = Doc.all
  end

  # GET /docs/1 or /docs/1.json
  def show
  end

  # GET /docs/new
  def new
    @doc = Doc.new
  end

  # GET /docs/1/edit
  def edit
  end

  # POST /docs or /docs.json
  def create
    @doc = Doc.new(doc_params)
    @user = current_user
    @doc.documentable = @user
    # @doc.save
    # path_to_pdf = @user.saved_resume
    # puts "\npath_to_pdf:\n#{path_to_pdf}"
    # # tmp_url = @user.resume.preview(resize_to_limit: [100, 100]).processed.url
    # # puts "key: #{@user.resume.key}path_to_pdf: #{path_to_pdf}"
    # document = Poppler::Document.new(path_to_pdf)

    # puts "document: #{document.inspect}"

    # raw_content = document.map { |page| page.get_text }.join
    # @doc.displayed_content.body = raw_content
    # arry_content = raw_content.split("●")
    # body_content = raw_content.gsub!("●", " ")
    # @doc.raw_body = raw_content
    # @doc.body = arry_content.join("<br>")

    respond_to do |format|
      if @doc.save
        format.html { redirect_to doc_url(@doc), notice: "Doc was successfully created." }
        format.json { render :show, status: :created, location: @doc }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /docs/1 or /docs/1.json
  def update
    respond_to do |format|
      if @doc.update(doc_params)
        format.html { redirect_to doc_url(@doc), notice: "Doc was successfully updated." }
        format.json { render :show, status: :ok, location: @doc }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /docs/1 or /docs/1.json
  def destroy
    @doc.destroy!

    respond_to do |format|
      format.html { redirect_to docs_url, notice: "Doc was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_doc
    @doc = Doc.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def doc_params
    params.require(:doc).permit(:name, :doc_type, :body, :raw_body, :documentable_id, :documentable_type, :current, :displayed_content)
  end
end
