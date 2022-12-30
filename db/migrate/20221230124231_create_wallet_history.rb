class CreateWalletHistory < ActiveRecord::Migration[7.0]
  def change
    create_table :wallet_histories do |t|
      t.integer :updated_by_user
      t.float :previous_balance
      t.float :updated_balance
      t.string :checkout_session_object_id
      t.references :wallet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
