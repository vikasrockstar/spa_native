class TransactionsController < ApplicationController
  before_action :authorize_request, only: [:create]

  def create
    transaction = Transaction.new(transaction_params)
    transaction.user_id = @current_user.id
    transaction.created_at = params['date']
    transaction.updated_at = params['date']
    if transaction.save
      render json: transaction, status: 201
    else 
      render json: { errors: transaction.errors.full_messages }, status: 422
    end
  end

  def transaction_params
    params.require(:transaction).permit(:amount, :bank_account_id, :description)
  end
end
