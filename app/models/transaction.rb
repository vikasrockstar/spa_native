class Transaction < ApplicationRecord
  belongs_to :bank_account, optional: true
  belongs_to :user

  scope :transactions_between, lambda {|start_date, end_date| where(created_at: start_date..end_date )}

end
