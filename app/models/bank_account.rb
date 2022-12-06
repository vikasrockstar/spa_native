class BankAccount < ApplicationRecord
	belongs_to :user
	before_create :active_account
	
	def deactive_account
	  bank_details = User.find_by_id(self.user_id).bank_accounts.where.not(id: id).last
	  bank_details.is_active = false
	  bank_details.save
	end

	private

	def active_account
    self.is_active = true
	end
end
