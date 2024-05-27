# frozen_string_literal: true

class UsageRate < ApplicationRecord
  belongs_to :electricity_plan

  validates :limit_kwh, uniqueness: { scope: :electricity_plan_id }
  validates :rate, presence: true
  validates :rate, numericality: { greater_than_or_equal_to: 0 }

  scope :sort_limit_kwh_asc_nulls_last, -> { order('limit_kwh ASC NULLS LAST') }

  def self.calculate_total(usage_kwh, usage_rates)
    sorted_usage_rates = usage_rates.sort_limit_kwh_asc_nulls_last
    sorted_usage_rates.each_with_object({ total: BigDecimal(0), calculated_kwh: BigDecimal(0) }) do |usage_rate, hash|
      price, calcuable_kwh = usage_rate.calculate_price_and_calcuable_kwh(usage_kwh, hash[:calculated_kwh])

      hash[:total] += price
      break hash[:total] unless calcuable_kwh

      hash[:calculated_kwh] += calcuable_kwh
    end
  end

  def calculate_price_and_calcuable_kwh(usage_kwh, calculated_kwh)
    uncalculated_kwh = BigDecimal(usage_kwh) - BigDecimal(calculated_kwh)
    calcuable_kwh = BigDecimal(limit_kwh.to_i) - BigDecimal(calculated_kwh)

    if limit_kwh.blank? || uncalculated_kwh <= calcuable_kwh
      price = uncalculated_kwh * rate
      [price]
    else
      price = calcuable_kwh * rate
      [price, calcuable_kwh]
    end
  end
end
