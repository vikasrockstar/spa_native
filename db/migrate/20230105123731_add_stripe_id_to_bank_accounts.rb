class AddStripeIdToBankAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :bank_accounts, :stripe_id, :string
  end
end
