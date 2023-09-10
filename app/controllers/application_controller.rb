class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception
  helper_method :current_order
  before_action :set_categories

  def current_order
    if session[:order_id].nil?
      current_user.orders.new
    else
      begin
        current_user.orders.find(session[:order_id])
      rescue ActiveRecord::RecordNotFound => e
        current_user.orders.new
      end
    end
  end

  private

  def set_categories
    @categories = ProductCategory.all
  end
end
