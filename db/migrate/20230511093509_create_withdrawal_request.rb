class CreateWithdrawalRequest < ActiveRecord::Migration[7.0]
  def change
    create_table :withdrawal_requests do |t|

      t.float :amount, default: 0.0
      t.integer :status, default: 0
      t.datetime :completion_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
