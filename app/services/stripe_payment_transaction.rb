class StripePaymentTransaction

  attr_reader :user, :event, :amount, :rating, :review

  def initialize(event)
    @event = event
    user_id = event.data.dig('data', 'object', 'metadata', 'reciever_user_id').to_i
    @rating = event.data.dig('data', 'object', 'metadata', 'rating').to_i
    @review = event.data.dig('data', 'object', 'metadata', 'review')
    @user = User.find_by(id: user_id)
    @amount = ((event.data.dig("data", "object", "amount_total").to_i / 100) * 0.9)&.round(2)
  end

  def add_to_wallet
    return if user.blank?
    user.reviews.create(rating: rating, review: review)
    user.transactions.create!(amount: amount, description: description, bank_account: user.bank_accounts&.active_accounts&.first )
    user.update_wallet(amount)
    event.update(status: 'processed')
  end

  def description
    event.data.dig("data", "object", "metadata", "payment_reason")
    # customer_detail = event.data.dig("data", "object", "customer_details")
    # "Customer #{customer_detail["name"]} with email #{customer_detail["email"]} has paid #{amount}"
  end
end
