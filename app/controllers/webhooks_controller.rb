class WebhooksController < ApplicationController

  def endpoint
    object_data = params['webhook']['data']['object']
    reciever_user_id = object_data['metadata']['reciever_user_id']
    amount = object_data['amount_total']
    checkout_session_object_id = object_data['object']['id']
    ActiveRecord::Base.transaction do
      user = User.find(reciever_user_id)
      wallet = user.wallet
      previous_balance = user.wallet.balance
      updated_balance = previous_balance + amount
      user.transactions.create(amount: amount)
      if user.wallet.update(balance: updated_balance)
        render json: 'success', status: 200
      else
        render json: 'failure', status: 400
      end
    end
  end
end
