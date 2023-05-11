class WithdrawalRequest < ApplicationRecord
  belongs_to :user
  validate :user_wallet_amount, on: :create
  enum :status, [ :pending, :processing, :processed, :failed ]
  
  def user_wallet_amount
    errors.add(:amount, "can't be more than wallet balance") if amount > user.wallet.balance
  end
end
