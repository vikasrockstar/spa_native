FactoryBot.define do
  factory :transaction do
    amount { 1.5 }
    bank_account { nil }
  end
end
