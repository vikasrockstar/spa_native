class QrCode < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  # validates :amount, uniqueness: { scope: :user_id }
  # validates :url, uniqueness: true

  def filter_attributes
    attributes.except('image_file_name', 'image_content_type', 'image_file_size', 'image_updated_at')
  end
end
