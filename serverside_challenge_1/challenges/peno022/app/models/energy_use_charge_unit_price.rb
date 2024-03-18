# frozen_string_literal: true

class EnergyUseChargeUnitPrice
  attr_reader :range, :price

  def initialize(range, price)
    @range = range
    @price = price
  end
end
