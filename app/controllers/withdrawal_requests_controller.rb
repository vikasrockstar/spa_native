class WithdrawalRequestsController < ApplicationController
  before_action :authorize_request, only: [:create, :index]

  def index
    withdrawal_request = @current_user.withdrawal_requests
    render json: { list: withdrawal_request }, status: 200
  end

  def create
    withdrawal_request = @current_user.withdrawal_requests.new(new_withdrawal_request_params)
    if withdrawal_request.save
      render json: withdrawal_request, status: 201
    else
      render json: { errors: withdrawal_request.errors.full_messages }, status: 422
    end
  end
  
  private

  def new_withdrawal_request_params
    params.require(:withdrawal_request).permit(:amount)
  end
end
