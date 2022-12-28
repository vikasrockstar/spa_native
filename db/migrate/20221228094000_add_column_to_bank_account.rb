class AddColumnToBankAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :bank_accounts, :frequency, :text
  end
end
