require 'stripe'
class StripePayment

  BASE_URL = ENV['BASE_URL']

  def initialize(user, amount = 0, product_name = 'Personal QR', custom_price = false, metadata={})
    # Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    amount = (amount.to_f * 100).to_i
    @current_user = user
    @product_name = product_name || 'Personal QR'
    @product = create_product
    @custom_price = custom_price
    @product_price = custom_price ? create_custom_price : create_product_price(amount)
    @metadata = metadata
  end

  attr_reader :product_name, :custom_price

  def create_payment_link
    payment_link = Stripe::PaymentLink.create(
      {
        line_items: [{ price: @product_price['id'], quantity: 1 }],
        metadata: { reciever_user_id: @current_user.id, payment_reason: payment_reason}.merge(@metadata),
        after_completion: { type: 'redirect', redirect: { url: "#{BASE_URL}/thanks" } }
      }
    )
    payment_link['url']
  end

  def create_product
    Stripe::Product.create({name: product_name})
  end

  def create_product_price(amount)
    Stripe::Price.create(
      { currency: 'aed', unit_amount: amount, product: @product['id'] }
    )
  end

  def create_custom_price
    Stripe::Price.create(
      { currency: 'aed', custom_unit_amount: {enabled: true}, product: @product['id'] }
    )
  end

  def payment_reason
    if custom_price
      'Personal QR'
    else
      product_name
    end
  end
end
