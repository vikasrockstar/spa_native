class CreateVersionManagers < ActiveRecord::Migration[7.0]
  def change
    create_table :version_managers do |t|
      t.string :device_type
      t.string :app_version
      t.string :message
      t.boolean :is_hard_update
      t.boolean :is_soft_update
      t.timestamps
    end
  end
end
