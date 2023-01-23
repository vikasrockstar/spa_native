require 'stripe'
class StripeService
  def initialize
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end

  def create_product
    product = Stripe::Product.create({name: 'Custard Apple'})
    # create_price(product)
  end

  def create_price(product)
    price = Stripe::Price.create({unit_amount: 100, currency: 'INR', product: product.id})
    # create_payment_link(price)
  end

  def create_payment_link(price, current_user)
    payment_link = Stripe::PaymentLink.create({line_items: [{price: price.id, quantity: 1}], metadata: {id: current_user.id, email: current_user.email}})
  end
end
