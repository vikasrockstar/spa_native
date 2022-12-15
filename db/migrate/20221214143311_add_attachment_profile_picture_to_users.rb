class AddAttachmentProfilePictureToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.attachment :profile_picture
    end
  end

  def down
    remove_attachment :users, :profile_picture
  end
end
