class Api::V2::PayoutsController < ApplicationController
  before_action :authorize_request

  def create
    service = StripeAccount.new(@current_user, @current_user.bank_accounts.first)
    service.find_or_create_stripe_customer
    service.find_or_create_stripe_account
    service.create_bank_account_token
    service.find_or_create_stripe_bank_account
    service.find_or_create_stripe_external_account
    service.payout
    render json: { message: 'success', status: 200 }
  end
end
