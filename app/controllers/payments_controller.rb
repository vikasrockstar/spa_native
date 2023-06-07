class PaymentsController < ActionController::Base
  layout 'custom_layout'
  protect_from_forgery with: :null_session
  before_action :set_amount_and_user, only: [:pay_link]

  def index
    @user = User.find_by(id: params[:user_id])
    render 'index'
  end
  
  def pay_link
    payment_link = StripePayment.new(@user, @amount.to_i, @product_name, false, {rating: @rating, review: @review}).create_payment_link
    redirect_to payment_link, allow_other_host: true
  end
  
  def thanks
  end
  private
  
  def set_amount_and_user
    user_id = params.dig(:user, :id)
    @user = User.find_by(id: user_id)
    @amount = params.dig(:payment, :amount)
    @product_name = params.dig(:payment, :product_name)
    @rating = params.dig(:payment, :rating)
    @review = params.dig(:payment, :review)
  end
end