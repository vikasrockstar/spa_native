class AddPaymentLinkToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :payment_link, :string
  end
end
