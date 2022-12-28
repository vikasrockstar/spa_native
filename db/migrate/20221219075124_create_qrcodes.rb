class CreateQrcodes < ActiveRecord::Migration[7.0]
  def change
    create_table :qrcodes do |t|
      t.string :url
      t.string :image
      t.float :amount
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
