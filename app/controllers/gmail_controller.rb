class GmailController < ApplicationController
  before_action :authorize_gmail, only: [:search]

  def search
    # search_term = params[:query]
    puts "params: #{params}"
    search_term = "from:*#{params[:query].downcase}"
    search_term += " is:unread" if params[:unread]
    puts "search_term: #{search_term}"
    @gmail_search_results = Message.search_and_save(@gmail, search_term)
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
end
