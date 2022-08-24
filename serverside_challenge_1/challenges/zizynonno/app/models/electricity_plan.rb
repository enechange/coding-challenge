class ElectricityPlan < ApplicationRecord
  belongs_to :electric_power_company
  has_many :basic_rate
  has_many :meter_rate

  validates :name, presence: true
end
