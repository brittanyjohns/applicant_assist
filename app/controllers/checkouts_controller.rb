class CheckoutsController < ApplicationController
  TRANSACTION_SUCCESS_STATUSES = [
    Braintree::Transaction::Status::Authorizing,
    Braintree::Transaction::Status::Authorized,
    Braintree::Transaction::Status::Settled,
    Braintree::Transaction::Status::SettlementConfirmed,
    Braintree::Transaction::Status::SettlementPending,
    Braintree::Transaction::Status::Settling,
    Braintree::Transaction::Status::SubmittedForSettlement,
  ]

  def new
    @current_order = current_order
    @client_token = gateway.client_token.generate
    @amount = @current_order.total
  end

  def show
    @transaction = gateway.transaction.find(params[:id])
    @result = _create_result_hash(@transaction)
    @order = current_user.orders.placed.last
  end

  def create
    @current_order = current_order
    @amount = @current_order.total
    # amount = params["amount"] # In production you should not take amounts directly from clients
    nonce = params["payment_method_nonce"]

    result = gateway.transaction.sale(
      amount: @amount,
      payment_method_nonce: nonce,
      :options => {
        :submit_for_settlement => true,
      },
    )

    if result.success? || result.transaction
      @current_order.placed!
      current_user.coins ||= 0
      current_user.coins += @current_order.total_coin_value
      current_user.save!
      flash[:notice] = "Nice! You just bought #{@current_order.total_coin_value} coins!"
      session[:order_id] = nil
      redirect_to checkout_path(result.transaction.id)
    else
      error_messages = result.errors.map { |error| "Error: #{error.code}: #{error.message}" }
      flash[:error] = error_messages
      redirect_to new_checkout_path
    end
  end

  def _create_result_hash(transaction)
    status = transaction.status

    if TRANSACTION_SUCCESS_STATUSES.include? status
      result_hash = {
        :header => "Sweet Success!",
        :icon => "success",
        :message => "Your transaction has been successfully processed.",
      }
    else
      @order = current_user.orders.placed.last
      @order.failed!
      result_hash = {
        :header => "Transaction Failed",
        :icon => "fail",
        :message => "Your transaction has failed with a status of #{status}. Please contact support.",
      }
    end
  end

  def gateway
    env = ENV["BT_ENVIRONMENT"]

    @gateway ||= Braintree::Gateway.new(
      :environment => env && env.to_sym,
      :merchant_id => ENV["BT_MERCHANT_ID"],
      :public_key => ENV["BT_PUBLIC_KEY"],
      :private_key => ENV["BT_PRIVATE_KEY"],
    )
  end
end
