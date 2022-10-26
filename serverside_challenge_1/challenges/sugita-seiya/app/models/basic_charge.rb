class BasicCharge < ApplicationRecord
  belongs_to :electricity_rate_plan

  validates :contract_amperage,
            presence: true,
            inclusion: { in: Constants::CONTRACT_AMPERAGE_TYPE },
            uniqueness: { scope: :electricity_rate_plan_id, message: 'プラン、契約アンペア数の組み合わせは存在します' }

  validates :charge_unit_price,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  validates :electricity_rate_plan_id,
            presence: true
end
