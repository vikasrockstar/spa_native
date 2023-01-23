class AddStripeBankAccountIdToBankAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :bank_accounts, :stripe_bank_account_id, :string
  end
end
