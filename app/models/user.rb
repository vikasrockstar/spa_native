class User < ApplicationRecord
  require File.join File.dirname(__FILE__), 'send_code'

  has_secure_password
  has_one_time_password length: 4, counter_based: true
  has_one_attached :profile_picture
  has_many :bank_accounts, dependent: :destroy
  has_one :wallet, dependent: :destroy

  validates :email, presence: true, uniqueness: { message: 'Email Id already exists' }
  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
  validates :mobile_number,:presence => true,
                 :numericality => true,
                 :presence => true,
                 :length => { :minimum => 10, :maximum => 10 }

  after_create :set_wallet

  def send_auth_code
    options = {
      to: mobile_with_code,
      body: "Your SPA Native Verification code is #{self.otp_code}. Please do not share it with anybody."
    }
    SendCode.new.send_sms(options)
  end

  def filter_password
    attributes.except('password_digest', 'otp_secret_key', 'otp_counter')
  end

  def set_wallet
    wallet = build_wallet
    wallet.save!
  end

  private

  def mobile_with_code
    country_code + mobile_number
  end
end
