class StripeAccountsController < ApplicationController
  before_action :authorize_request, only: [:create]

  # def show
  #   stripe_user  = StripeService.new.find_or_create_user(@current_user)
  #   render json: {stripe_user: stripe_user},success: :ok
  # end

  def create
    StripeAccount.new.find_or_create_user(@current_user)
    stripe_bank_account = StripeAccount.new.create_bank_account(@current_user, @current_user.bank_accounts.first)
    token = StripeAccount.new.create_bank_account_token(@current_user.bank_accounts.first)
    external_account = StripeAccount.new.create_external_account(@current_user, stripe_bank_account, token)
    render json: {stripe_user: external_account},success: :ok
  end
  
end
