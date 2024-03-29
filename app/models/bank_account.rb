class BankAccount < ApplicationRecord
  acts_as_paranoid
  validates_as_paranoid
  belongs_to :user
  before_create :active_account
  has_many :transactions
  after_create :user_bank_activate

  validates :account_number,:presence => true,
                 :numericality => true,
                 :presence => true,
                 :length => { :minimum => 10, :maximum => 18 }
  validates_uniqueness_of_without_deleted :account_number
  validates :bank_name, :account_holder_name, presence: true

  scope :active_accounts, -> { where(is_active: true) }

  private

  def active_account
    self.is_active = true
  end
  
  def user_bank_activate
    return if user.bank_added?
    
    user.update(bank_added: true)
  end
end
