# frozen_string_literal: true

class EnergyUseChargeTable
  attr_reader :unit_prices

  def initialize(unit_prices)
    @unit_prices = unit_prices.sort_by { |unit_price| unit_price.range.begin }
  end

  def calculate_charge(consumption)
    total_charge = 0
    last_range_max = 0

    unit_prices.each do |unit_price|
      break if consumption < unit_price.range.begin

      consumption_in_this_range = calculate_consumption_in_range(consumption, unit_price.range, last_range_max)
      total_charge += consumption_in_this_range * unit_price.price
      last_range_max = unit_price.range.end
    end

    total_charge
  end

  private

  def calculate_consumption_in_range(consumption, range, last_range_max)
    if range.cover?(consumption)
      consumption - last_range_max
    else
      range.end - last_range_max
    end
  end
end
