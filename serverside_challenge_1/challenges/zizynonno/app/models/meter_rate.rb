class MeterRate < ApplicationRecord
  belongs_to :electricity_plan
  attr_accessor :price
end
