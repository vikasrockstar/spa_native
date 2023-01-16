require 'stripe'
class StripeAccount
  def initialize
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end


  def find_or_create_user(current_user)
    if current_user.stripe_user_id.present?
      stripe_user = Stripe::Customer.retrieve(current_user.stripe_user_id)
    else
      stripe_user = Stripe::Customer.create({name: current_user.first_name,email: current_user.email,phone: current_user.mobile_number})
      current_user.update(stripe_user_id: stripe_user.id)
    end
    stripe_user
  end

  def create_bank_account(current_user,bank_account)
    if bank_account.stripe_bank_account_id.present?
      stripe_bank_account = Stripe::Account.retrieve(bank_account.stripe_bank_account_id)
    else
      stripe_bank_account = Stripe::Account.create({type: bank_account.account_type, country: bank_account.country, email: current_user.email})
      bank_account.update(stripe_bank_account_id: stripe_bank_account.id)
    end
    stripe_bank_account
  end

  def create_bank_account_token(account)
    Stripe::Token.create({
      bank_account: {
        country: account.country,
        currency:  account.currency,
        account_holder_name: account.account_holder_name,
        account_holder_type: 'individual',
        routing_number: account.routing_number,
        account_number: account.account_number
      }
    })
    # Stripe::Token.create({bank_account: {country: bank_account.country,currency: bank_account.currency,account_holder_name: bank_account.account_holder_name,routing_number: bank_account.routing_number,account_number: bank_account.account_number}})
  end

  def create_external_account(current_user, account, token)
    Stripe::Account.create_external_account(account.id,{external_account: token.id})  
  end
end