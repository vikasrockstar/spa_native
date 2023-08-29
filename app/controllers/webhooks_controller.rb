class WebhooksController < ApplicationController
  def create
    event = create_event(params)

    StripePaymentTransaction.new(event).add_to_wallet if params[:type] == "checkout.session.completed"
    head :ok
  end

  private

  def create_event(params)
    Event.create!(
      data: params,
      source: 'stripe',
      event_type: params[:type]
    )
  end
end
