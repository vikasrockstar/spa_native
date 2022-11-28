class CreateBankAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_accounts do |t|
      t.string   :bank_name
      t.string   :account_holder_name
      t.string   :account_number
      t.string   :account_type
      t.integer   :user_id
      t.text   :address
      t.boolean :is_active
      t.timestamps
    end
  end
end
