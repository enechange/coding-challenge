class ElectricPowerCompany < ApplicationRecord
  has_many :electricity_plans
  attr_accessor :name
end
