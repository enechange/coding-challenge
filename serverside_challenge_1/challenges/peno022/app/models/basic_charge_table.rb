# frozen_string_literal: true

class BasicChargeTable
  attr_reader :unit_prices

  def initialize(unit_prices)
    @unit_prices = unit_prices
  end

  def calculate_charge(contract_amperage)
    unit_prices[contract_amperage]
  end
end
