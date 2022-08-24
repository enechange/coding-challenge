class BasicRate < ApplicationRecord
  belongs_to :electricity_plan

  CONTRACT_AMPERES = [10, 15, 20, 30, 40, 50, 60]
  validates :ampere,
    inclusion: { in: CONTRACT_AMPERES },
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
