# frozen_string_literal: true

class ElectricityProvider < ApplicationRecord
  has_many :electricity_plans
end
