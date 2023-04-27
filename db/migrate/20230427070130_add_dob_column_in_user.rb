class AddDobColumnInUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :dob, :date
  end
end
