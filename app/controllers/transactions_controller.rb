class TransactionsController < ApplicationController
  before_action :authorize_request, only: [:create, :index]
  PER_PAGE = 10

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

  def index
    page_number = params[:page_number].to_i
    transactions = @current_user.transactions
    total_pages = transactions.count/PER_PAGE
    next_page = page_number >= total_pages - 1 ? -1 : page_number + 1
    transactions = transactions.order(created_at: :desc).offset(PER_PAGE*page_number).limit(PER_PAGE)
    render json: { list: transactions, page_number: next_page }, status: 200
  rescue
    render json: { errors: ['Invalid parameters'] }, status: 200
  end
end
