class Transaction < ApplicationRecord
  belongs_to :bank_account
  belongs_to :user
end
