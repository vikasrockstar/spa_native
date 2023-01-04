class WebhooksController < ApplicationController
  before_action :check_webhook_authenticity, only: [:endpoint]

  def endpoint
    object_data = params['webhook']['data']['object']
    reciever_user_id = object_data['metadata']['reciever_user_id']
    amount = object_data['amount_total']
    checkout_session_object_id = object_data['id']
    ActiveRecord::Base.transaction do
      user = User.find(reciever_user_id)
      wallet = user.wallet
      previous_balance = user.wallet.balance
      updated_balance = previous_balance + amount
      user.transactions.create(amount: amount)
      if wallet.update(balance: updated_balance)
        wallet.wallet_histories.create(previous_balance: previous_balance, updated_balance: updated_balance, checkout_session_object_id: checkout_session_object_id)
        render json: 'success', status: 200
      else
        render json: 'failure', status: 400
      end
    end
  end

  def check_webhook_authenticity
    begin
      event = StripeService.check_authenticity(request)
    rescue
      render json: 'failure', status: 400
    end
  end
end
