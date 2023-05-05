class AddBankAddedColumnInUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :bank_added, :boolean, default: false
  end
end
