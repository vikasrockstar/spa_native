require 'stripe'
Stripe.api_version = '2018-02-28'
Stripe.api_key = ENV['STRIPE_SECRET_KEY']
