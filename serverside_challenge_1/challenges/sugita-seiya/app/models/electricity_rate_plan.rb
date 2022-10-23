class ElectricityRatePlan < ApplicationRecord
  belongs_to :electric_power_provider
  has_many :basic_charges, dependent: :destroy
  has_many :usage_charges, dependent: :destroy
end
