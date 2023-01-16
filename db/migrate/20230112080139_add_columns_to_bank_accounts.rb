class AddColumnsToBankAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :bank_accounts, :routing_number, :integer
    add_column :bank_accounts, :currency, :string
    add_column :bank_accounts, :country, :string
    add_column :bank_accounts, :stripe_bank_account_id, :string
  end
end
