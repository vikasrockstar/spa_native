class BankAccountsController < ApplicationController
  before_action :authorize_request, only: [:create, :show, :index, :destroy, :update]
  before_action :set_bank_account, only: [:show, :destroy, :update]

	def create
		bank_account = BankAccount.new(bank_details_params)
    bank_account.user_id = @current_user.id
		if bank_account.save
      deactive_other_bank_accounts(bank_account.id)
      render json: bank_account, status: 201
    else
      render json: { errors: bank_account.errors.full_messages }, status: 422
    end
	end

	def show
    render json: @bank_account, status: 200
	end

	def index
	  bank_accounts = @current_user.bank_accounts.order(is_active: :desc)
    render json: { list: bank_accounts }, status: 200
	end

  def destroy
    activate_last_account = @bank_account.is_active
    if @bank_account.destroy
      @current_user.bank_accounts&.last&.update(is_active: true) if activate_last_account
      render json: { message: ['successfully deleted'] }, status: 200
    else
      render json: { errors: @bank_account.errors.full_messages }, status: 400
    end
  end

  def update
    if @bank_account.update(bank_details_params)
      render json: { data: @bank_account, message: ['successfully updated'] }, status: 200
    else
      render json: { errors: @bank_account.errors.full_messages }, status: 422
    end
  end

  private

  def bank_details_params
    params.require(:bank_account).permit(:bank_name, :account_holder_name, :account_number, :account_type, :address, :ifsc_code, :frequency)
  end

  def set_bank_account
    @bank_account = @current_user.bank_accounts.find_by(id: params[:id])
    if @bank_account.nil?
      render json: {errors: ['bank detail not found']}, status: 400
    end
  end

  def deactive_other_bank_accounts(current_account_id)
    other_active_bank_accounts =  @current_user.bank_accounts&.active_accounts&.where.not(id: current_account_id)
    other_active_bank_accounts&.update_all(is_active: false)
  end
end
