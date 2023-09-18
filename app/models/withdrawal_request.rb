class WithdrawalRequest < ApplicationRecord
  belongs_to :user
  validate :process_user_wallet_amount, on: :create
  enum :status, [ :pending, :processing, :processed, :failed ]
  
  def process_user_wallet_amount
    wallet_balance = user.wallet.balance
    if amount > wallet_balance
      errors.add(:amount, "can't be more than wallet balance")
    else
      user.wallet.update(balance: wallet_balance - amount)
    end
  end
end
