# frozen_string_literal: true

class UsageRate < ApplicationRecord
  belongs_to :electricity_plan

  validates :limit_kwh, uniqueness: { scope: :electricity_plan_id }
  validates :rate, presence: true
  validates :rate, numericality: { greater_than_or_equal_to: 0 }
end
