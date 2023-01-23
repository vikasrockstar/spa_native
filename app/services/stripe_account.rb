require 'stripe'

class StripeAccount
  # include Rails.application.routes.url_helpers
  attr_reader :user, :account

  def initialize(current_user, user_bank_account)
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    @user = current_user
    @account = user_bank_account
  end

  def find_or_create_stripe_customer
    return if user.customer_stripe_id.present?
    stripe_customer = Stripe::Customer.create({ name: user.first_name, email: user.email, description: 'Test Customer', metadata: { id: user.id, email: user.email } })
    user.update(customer_stripe_id: stripe_customer.id)
  end

  def find_or_create_stripe_account
    return if user.bank_accounts.first.stripe_id.present?
    stripe_account = Stripe::Account.create({
      type: 'standard',
      country: 'US',
      email: account.user.email,
      business_type: 'individual',
      individual: {email: account.user.email},
      business_profile: {
        name: account.user.email,
        product_description: 'testing',
        support_email: 'test@gmail.com',
        support_phone: '9926490299',
        support_url: 'testing.com',
        url: 'google.com'
      },
      external_account: {
        object: 'bank_account',
        country: 'US',
        currency: 'usd',
        routing_number: '110000000',
        account_number: '000123456789'
      },
      tos_acceptance: {
        service_agreement: 'full'
      }
    })
    account.update(stripe_id: stripe_account.id)
  end

  def create_bank_account_token
    @bank_account_token = Stripe::Token.create({
      bank_account: {
        country: 'US',
        currency: 'usd',
        account_holder_name: account.account_holder_name,
        account_holder_type: 'individual',
        routing_number: '110000000',
        account_number: '000123456789'
      }
    })
  end

  def find_or_create_stripe_bank_account
    return if user.bank_accounts.first.stripe_bank_account_id.present?
    stripe_bank_account = Stripe::Customer.create_source(
      user.customer_stripe_id,
      {source: @bank_account_token},
    )
    account.update(stripe_bank_account_id: stripe_bank_account.id)
  end

  def find_or_create_stripe_external_account
    return if user.bank_accounts.first.stripe_external_account_id.present?
    stripe_external_account = Stripe::Account.create_external_account(
      account.stripe_id,
      {
        external_account: @bank_account_token
      }
    )
    account.update(stripe_external_account_id: stripe_external_account.id)
  end

  def payout
    @payout = Stripe::Payout.create({
      amount: 400,
      currency: 'inr',
      destination: account.stripe_bank_account_id,
      description: 'STRIPE PAYOUT'
    })
  end
end
