FactoryBot.define do
  factory :review do
    rating { 1 }
    review { "MyText" }
    user { nil }
  end
end
