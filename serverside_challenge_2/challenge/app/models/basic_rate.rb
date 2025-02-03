class BasicRate < ApplicationRecord
  belongs_to :plan

  VALID_AMPERES = [10, 15, 20, 30, 40, 50, 60].freeze

  validates :ampere, presence: true, inclusion: { in: VALID_AMPERES }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
