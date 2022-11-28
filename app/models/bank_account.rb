class BankAccount < ApplicationRecord
	belongs_to :user
	before_save :active_account
	

	def deactive_account
	  User.find_by_id(id: self.user_id).bank_accounts.where.not(id: id).last
	  self.is_active = true
	  
	end


	private
	def active_account
    self.is_active = true
	end
end
