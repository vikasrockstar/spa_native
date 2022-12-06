class BankAccountsController < ApplicationController
  before_action :authorize_request, only: [:create, :show, :index]

	def create
		bank_account = BankAccount.new(bank_details_params)
		if bank_account.save
      bank_account.deactive_account
      render json: bank_account, status: 201
    else
      render json: { errors: bank_account.errors }, status: 422
    end
	end

	def show
    bank_account = @current_user.bank_accounts.find_by(id: params[:id])
    if bank_account
      render json: bank_account, status: 201
    else
      render json: { errors: 'bank detail not found' }, status: 400
    end
	end

	def index
		bank_account = @current_user.bank_accounts
		if bank_account
      render json: { list: bank_account }, status: 201
    else
      render json: { errors: 'bank detail not found' }, status: 400
    end
	end

  private
  def bank_details_params
    params.require(:bank_account).permit(:bank_name, :account_holder_name, :account_number, :account_type, :user_id, :address, :is_active)
  end
end
