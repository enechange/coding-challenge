# frozen_string_literal: true

class BasicCharge < ApplicationRecord
  belongs_to :power_supply_plan
end
