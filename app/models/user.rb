class User < ApplicationRecord
  require File.join File.dirname(__FILE__), 'send_code'

  BASE_URL = ENV['BASE_URL']
  
  has_secure_password
  has_one_time_password length: 4, counter_based: true
  has_one_attached :profile_picture
  # validates_acceptance_of :profile_picture, content_type: /\Aimage\/.*\z/
  has_many :bank_accounts, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_one :wallet, dependent: :destroy
  has_many :qr_codes
  has_many :withdrawal_requests
  has_many :reviews
  validates :email, presence: true, uniqueness: { message: 'Id already exists' }
  validates :first_name, :last_name, :country_chars, :country_code, presence: true
  validates :mobile_number, uniqueness: true,
                 :numericality => true,
                 :presence => true,
                 :length => { :minimum => 8, :maximum => 10 }

  after_create :set_wallet
  after_save :set_personal_payment_link

  scope :unverified_users, -> { where(is_mobile_verified: false) }

  def send_auth_code
    options = {
      to: mobile_with_code,
      body: "Your My Tips Verification code is #{self.otp_code}. Please do not share it with anybody."
    }
    SendCode.new.send_sms(options)
  end

  def profile_picture_url
    if self.profile_picture.attached?
      Rails.application.routes.url_helpers.url_for(self.profile_picture)
    else
      nil
    end
  end

  def filter_attributes
    attributes.except('password_digest', 'otp_secret_key', 'otp_counter', 'profile_picture_file_name', 'profile_picture_content_type', 'profile_picture_file_size', 'profile_picture_updated_at')
  end

  def set_wallet
    wallet = build_wallet
    wallet.save!
  end

  def full_name
    first_name + " " + last_name
  end

  def set_personal_payment_link
    return if payment_link.present?

    # payment_link = StripePayment.new(self, 0, full_name, true).create_payment_link
    payment_link = "#{BASE_URL}/user_payment?user_id=#{id}&product_name=Personal%20QR"
    update(payment_link: payment_link)
  end

  def update_wallet(amount)
    balance = wallet.balance + amount
    wallet.update(balance: balance)
  end

  def personal_rating
    return 0 if reviews.blank?
    rating = 0
    reviews.each{|review| rating+= review.rating.to_f}
    rating/reviews.count
  end

  private

  def mobile_with_code
    country_code + mobile_number
  end
end
