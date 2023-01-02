class CreateVersionManagers < ActiveRecord::Migration[7.0]
  def change
    create_table :version_managers do |t|
      t.string :device_type
      t.string :app_version
      t.string :message
      t.boolean :is_force_update
      t.boolean :is_soft_update
      t.timestamps
    end
    data = {
      app_version: "1.0.0",
      is_force_update: :true,
      is_soft_update:  :true,
      message: "There is newer version available for download! Please update the app by visiting the Store"
    }

    VersionManager.create(data.merge!(device_type: "ios"))
    VersionManager.create(data.merge!(device_type: "android"))
  end
end
