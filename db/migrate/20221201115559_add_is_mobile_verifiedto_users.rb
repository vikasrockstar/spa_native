class AddIsMobileVerifiedtoUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_mobile_verified, :boolean, default: false
  end
end
