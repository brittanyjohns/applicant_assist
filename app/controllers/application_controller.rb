class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception
  helper_method :current_order
  before_action :set_categories

  def current_order
    if session[:order_id].nil?
      order = current_user.orders.in_progress.last || current_user.orders.create!
    else
      begin
        order = current_user.orders.in_progress.find(session[:order_id])
      rescue ActiveRecord::RecordNotFound => e
        order = current_user.orders.create!
      end
    end
    session[:order_id] = order.id
    order
  end

  private

  def set_categories
    @categories = ProductCategory.all
  end
end
