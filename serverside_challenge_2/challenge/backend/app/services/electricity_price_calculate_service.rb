# frozen_string_literal: true

class ElectricityPriceCalculateService
  def initialize(ampere, usage)
    @ampere = ampere
    @usage = usage
  end

  def calc
    Provider.order(:id).map { |provider| provider.electricity_prices(@ampere, @usage) }.flatten
  end
end
