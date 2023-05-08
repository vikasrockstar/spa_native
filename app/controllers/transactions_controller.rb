class TransactionsController < ApplicationController
  before_action :authorize_request, only: [:create, :index, :graph_data]
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
    transactions = transactions.where('description LIKE ?', "%#{params[:search_term]}%") if params[:search_term].present?
    total_pages = transactions.count/PER_PAGE
    next_page = page_number >= total_pages - 1 ? -1 : page_number + 1
    transactions = transactions.order(created_at: :desc).offset(PER_PAGE*page_number).limit(PER_PAGE)
    render json: { list: transactions, page_number: next_page }, status: 200
  rescue
    render json: { errors: ['Invalid parameters'] }, status: 200
  end

  def graph_data
    if params[:type].present?
     data = []
     case params[:type]
      when "weekly"
        transactions = @current_user.transactions.transactions_between(1.week.ago, Time.now)
        current_day = Time.now.end_of_day
        (0..6).to_a.each do  |day|
          current_day_trans = transactions.transactions_between(current_day - 1.day, current_day)
           data_hash = {
            :amount => current_day_trans.present? ? current_day_trans.sum(:amount) : 0,
            :date => current_day,
            :value_for => current_day.strftime('%a')
           }
           data << data_hash
          current_day = current_day - 1.day
          end

      when "monthly"
        transactions = @current_user.transactions.transactions_between(1.year.ago, Time.now)
        current_month = Time.now.end_of_month
        (0..11).to_a.each do  |day|
          current_month_trans = transactions.transactions_between(current_month - 1.months, current_month)
           data_hash = {
            :amount => current_month_trans.present? ? current_month_trans.sum(:amount) : 0,
            :date => current_month,
            :value_for => current_month.strftime('%b %y')
          }
          data << data_hash
          current_month = current_month - 1.months
        end
      end
      render json: { list: data, type: params[:type] }, status: 200
    else
      render json: {errors: ['incorrect or invalid params']}
    end
  end
end
