class AddColumnToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :description, :string, default: 'plumbing'
  end
end
