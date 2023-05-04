class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.json :data
      t.string :source
      t.string :event_type
      t.text :processing_errors
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
