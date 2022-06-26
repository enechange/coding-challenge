class BasicFee < ApplicationRecord
  belongs_to :plan

  with_options presence: true do
    validates :ampere, inclusion: { in: Api::V1::ElectricityChargeSimulation::AMPERE_LIST }
    validates :base_fee
  end
end
