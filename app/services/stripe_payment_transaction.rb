class StripePaymentTransaction
  def initialize(event)
    @event = event
    user_id = event.data.dig("data", "object", "metadata", "reciever_user_id").to_i
    @user = User.find_by(id: user_id)
    @amount = event.data.dig("data", "object", "amount_subtotal").to_i / 100
  end
  
  attr_reader :user, :event, :amount
  def add_to_wallet
    return if user.blank? || user.bank_accounts.blank?

    user.transactions.create!(amount: amount, description: description, bank_account: user.bank_accounts.active_accounts.first )
    user.update_wallet(amount)
    event.update(status: 'processed')
  end
  
  def description
    customer_detail = event.data.dig("data", "object", "customer_details")
    "Customer #{customer_detail["name"]} with email #{customer_detail["email"]} has paid #{amount}"
  end
end