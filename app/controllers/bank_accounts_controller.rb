class BankAccountsController < ApplicationController
  before_action :authorize_request, only: [:create, :show, :index]

	def create
		bank_detail = BankAccount.new(bank_details_params)
		if bank_detail.save
      bank_detail.deactive_account
      render json: { bank_details: bank_detail }, status: 201
    else
      render json: { errors: bank_detail.errors }, status: 422
    end
	end

	def show
	  render json: { bank_details: @bank_details }, status: 200
	end

	def index
		bank_details = current_user.bank_accounts
		if bank_details
      render json: { bank_details: bank_details }, status: 201
    else
      render json: { errors: 'bank detail not found' }, status: 400
    end
	end

  private
  def bank_details_params
    params.require(:bank_account).permit(:bank_name, :account_holder_name, :account_number, :account_type, :user_id, :address, :is_active)
  end

  def set_bank_detail
  	@bank_detail = current_user.bank_accounts.find_by(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: 'bank detail not found', status: 400
  end
end
