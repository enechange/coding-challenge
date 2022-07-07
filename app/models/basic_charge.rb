class BasicCharge < ApplicationRecord
  belongs_to :electricity_rate_plan

  validates :contract_amperage,
            presence: true,
            inclusion: { in: Constants::CONTRACT_AMPERAGE_TYPE },
            uniqueness: { scope: :electricity_rate_plan_id }

  validates :charge_unit_price,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  validates :electricity_rate_plan_id,
            presence: true
end
