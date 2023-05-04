class AddNewColumnsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :business_id_card, :string
    add_column :users, :address, :text
    add_column :users, :about_me, :text
  end
end
