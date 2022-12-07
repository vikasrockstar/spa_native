class AddIfscCodeToBankAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :bank_accounts, :ifsc_code, :string
  end
end
