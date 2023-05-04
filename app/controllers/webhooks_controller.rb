class WebhooksController < ApplicationController
  def create
    event = Event.create!(
      data: params,
      source: params[:source],
      event_type: params[:type]
    )
    
    if event.event_type == 'checkout.session.completed'
      StripePaymentTransaction.new(event).add_to_wallet
    end
  end
end
