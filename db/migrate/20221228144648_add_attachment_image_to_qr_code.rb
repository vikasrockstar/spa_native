class AddAttachmentImageToQrCode < ActiveRecord::Migration[7.0]
  def change
    change_table :qr_codes do |t|
      t.attachment :image
    end
  end

  def down
    remove_attachment :qr_codes, :image
  end
end
