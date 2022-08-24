class MeterRate < ApplicationRecord
  belongs_to :electricity_plan

  attr_accessor :usage

  validates :min_usage,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :max_usage,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
