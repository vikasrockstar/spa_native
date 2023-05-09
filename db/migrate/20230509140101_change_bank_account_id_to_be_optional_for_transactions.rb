class ChangeBankAccountIdToBeOptionalForTransactions < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :transactions, column: :bank_account_id, name: 'fk_rails_e6e00de26d'
    change_column :transactions, :bank_account_id, :integer, null: true
  end
end
