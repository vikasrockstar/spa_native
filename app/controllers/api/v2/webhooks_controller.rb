class Api::V2::WebhooksController < ApplicationController
  
  def create
    endpoint_secret = ENV['STRIPE_SIGNING_SECRET_KEY']
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e

      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      status 400
      return
    end

    # Handle the event
    case event.type
    when 'checkout.session.completed'
      user_id = params[:data][:object][:metadata][:id].to_i
      amount = params[:data][:object][:amount_subtotal]
      update_user_wallet(user_id, amount)
      puts 'Checkout session completed was successful!'
    else
      puts "Unhandled event type: #{event.type}"
    end
    render json: { message: 'success', status: 200 }
  end

  def update_user_wallet(user_id, amount)
    user = User.find_by(id: user_id)
    balance = user.wallet.balance
    current_balance = balance + amount
    user.wallet.update(balance: current_balance)
  end
end
