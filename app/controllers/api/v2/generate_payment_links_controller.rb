class Api::V2::GeneratePaymentLinksController < ApplicationController
  before_action :authorize_request

  def user_payment_link
    stripe_service = StripeService.new
    product = stripe_service.create_product
    price = stripe_service.create_price(product)
    payment_link = stripe_service.create_payment_link(price, @current_user)
    render json: { payment_link: payment_link }
  end
end
