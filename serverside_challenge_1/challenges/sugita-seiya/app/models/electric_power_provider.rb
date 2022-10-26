class ElectricPowerProvider < ApplicationRecord
  has_many :electricity_rate_plans, dependent: :destroy

  validates :name,
            presence: true,
            uniqueness: true
end
