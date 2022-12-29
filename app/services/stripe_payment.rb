require 'stripe'
class StripePayment
  def initialize(user, amount)
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    @current_user = user
    @product = create_product
    @product_price = create_product_price(amount)
  end

  def create_payment_link
    payment_link = Stripe::PaymentLink.create(
      {
        line_items: [{price: @product_price['id'], quantity: 1}],
        metadata: {reciever_user_id: @current_user.id},
        after_completion: {type: 'redirect', redirect: {url: 'https://example.com'}},
      },
    )
    payment_link['url']
  end

  def create_product
    Stripe::Product.create({name: 'Gold Special'})
  end

  def create_product_price(amount)
    Stripe::Price.create(
      {currency: 'usd', unit_amount: amount, product: @product['id']},
    )
  end
end
