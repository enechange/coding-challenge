# frozen_string_literal: true

class ElectricityPlanBasicFee < ApplicationRecord
  belongs_to :electricity_plan

  VALID_AMPERES = [10, 15, 20, 30, 40, 50, 60].freeze

  validates :ampere, inclusion: { in: VALID_AMPERES, message: '%<value>s is not a valid ampere' }
end
