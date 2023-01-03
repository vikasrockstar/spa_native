class BankAccount < ApplicationRecord
  acts_as_paranoid
  validates_as_paranoid
  belongs_to :user
  before_create :activate_account
  has_many :transactions
  after_create :deactivate_other_account

  validates :account_number, presence: true,
                             numericality: true,
                             length: { minimum: 10, maximum: 18 }
  validates_uniqueness_of_without_deleted :account_number
  validates :bank_name, :account_holder_name, presence: true

  scope :active_accounts, -> { where(is_active: true) }
  
  def deactivate_other_account
    user.bank_accounts.where.not(id: id).update_all(is_active: false)
  end

  private

  def activate_account
    self.is_active = true
  end
end
