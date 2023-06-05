class Review < ApplicationRecord
  belongs_to :user
  validates :rating, comparison: { less_than_or_equal_to: 5 }

end
