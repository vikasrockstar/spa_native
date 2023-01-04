require 'stripe'
class StripeService
  def initialize(user, amount)
    set_api_keys
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

  def create_bank_transfer
    source = create_source
    customer = create_customer
    bank_account = attach_source_to_customer(customer, source)
    payout = create_payout(bank_account)
  end

  def self.check_authenticity(request)
    set_api_keys
    endpoint_secret = ENV['STRIPE_WEHBOOK_SIGNING_SECRET']
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    payload = request.body.read
    event = Stripe::Webhook.construct_event(
      payload, sig_header, endpoint_secret
    )
    event
  end

  private

  def create_source
    Stripe::Source.create({
      type: 'ach_credit_transfer',
      currency: 'usd',
      owner: {
        email: @current_user.email,
      },
    })
  end

  def create_customer
    Stripe::Customer.create(
      {email: @current_user.email, source: source['id']},
    )
  end

  def create_payout(bank_account)
    Stripe::Payout.create({
      amount: 1100,
      currency: 'usd',
      destination: 'bank_account',
    })
  end

  def create_bank_account
    {}
  end

  def attch_source_to_customer(customer, source)
    Stripe::Customer.create_source(
      customer['id'],
      {
        source: source['id'],
      }
    )
  end

  def create_product
    Stripe::Product.create({name: 'Gold Special'})
  end

  def create_product_price(amount)
    Stripe::Price.create(
      {currency: 'usd', unit_amount: amount, product: @product['id']},
    )
  end

  def self.set_api_keys
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end
end
