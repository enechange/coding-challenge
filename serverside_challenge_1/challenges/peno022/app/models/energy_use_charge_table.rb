# frozen_string_literal: true

class EnergyUseChargeTable
  attr_reader :unit_prices

  def initialize(unit_prices)
    @unit_prices = unit_prices.sort_by { |unit_price| unit_price.range.begin }
  end

  # 従量料金を計算する。単位は銭。（100銭 = 1円）
  # 従量料金は消費電力量の区分ごとに単価が異なるため、消費した電力量に応じて料金を計算する。
  # 例） 0〜120kwhまでは1kwhあたり19円88銭、121〜300kwhまでは1kwhあたり26円48銭、301kwh以上は1kwhあたり30円57銭
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
