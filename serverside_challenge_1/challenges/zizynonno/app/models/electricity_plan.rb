class ElectricityPlan < ApplicationRecord
  belongs_to :electric_power_company
  has_one :basic_rate
  has_one :meter_rate
  attr_accessor :name
end
