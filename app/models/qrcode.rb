class Qrcode < ApplicationRecord
  belongs_to :user
  has_one_attached :qrcode_image
  validates :amount, uniqueness: {scope: :user_id }
end
