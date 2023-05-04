class Event < ApplicationRecord
  enum :status, [ :pending, :processing, :processed, :failed ]
end
