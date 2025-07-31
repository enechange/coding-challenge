# frozen_string_literal: true

class Provider < ApplicationRecord
  has_many :power_supply_plans
end
