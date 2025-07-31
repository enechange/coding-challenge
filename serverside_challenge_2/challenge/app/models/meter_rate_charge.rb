# frozen_string_literal: true

class MeterRateCharge < ApplicationRecord
  belongs_to :power_supply_plan

  def calculate_charge(meter_rate)
    min_rate = min_meter_rate
    max_rate = max_meter_rate
    step_price = price
    return 0 if min_rate > meter_rate

    if max_rate.nil?
      return step_price * meter_rate if min_rate.zero?

      return step_price * (meter_rate - min_rate + 1)
    end
    if max_rate.to_i < meter_rate.to_i
      return step_price * (max_rate - min_rate) if min_rate.zero?

      step_price * (max_rate - min_rate + 1)
    else
      return step_price * (meter_rate - min_rate) if min_rate.zero?

      step_price * (meter_rate - min_rate + 1)
    end
  end
end
