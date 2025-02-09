# frozen_string_literal: true

class ElectricityPlan < ApplicationRecord
  belongs_to :electricity_provider

  has_many :electricity_plan_basic_fees
  has_many :electricity_plan_usage_fees
end
