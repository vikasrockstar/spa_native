class AddSuspendedColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :suspended, :boolean, default: false
  end
end
