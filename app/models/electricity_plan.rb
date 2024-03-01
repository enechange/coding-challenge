# frozen_string_literal: true

class ElectricityPlan
  attr_reader :provider, :name, :basic_charge_table, :enery_use_charge_table

  def initialize(provider, name, basic_charge_table, enery_use_charge_table)
    @provider = provider
    @name = name
    @basic_charge_table = basic_charge_table
    @enery_use_charge_table = enery_use_charge_table
  end

  def calculate_price(contract_amperage, consumption)
    basic_charge = basic_charge_table.calculate_charge(contract_amperage)
    energy_use_charge = enery_use_charge_table.calculate_charge(consumption)

    # 基本料金と従量料金の合計額の1円未満は切り捨て
    (basic_charge + energy_use_charge).div(100)
  end

  def for_amperage?(contract_amperage)
    basic_charge_table.unit_prices.key?(contract_amperage)
  end
end
