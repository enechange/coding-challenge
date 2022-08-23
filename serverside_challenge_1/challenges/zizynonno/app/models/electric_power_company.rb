class ElectricPowerCompany < ApplicationRecord
  has_many :electricity_plans

  validates :name, presence: true
end
