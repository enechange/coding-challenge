class UsageCharge < ApplicationRecord
  belongs_to :electricity_rate_plan

  validates :charge_unit_price,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  validates :minimum_usage,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 },
            uniqueness: { scope: [:electricity_rate_plan_id, :max_usage] }

  validates :max_usage,
            presence: true,
            numericality: { less_than_or_equal_to: Constants::MAXIMUM_ELECTRICITY_USAGE }

  validates :electricity_rate_plan_id,
            presence: true
end
