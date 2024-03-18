# frozen_string_literal: true

require 'yaml'

class BuildElectricityPlansService
  # yamlファイルから読み込まれたデータを元に、電力会社のプランをElectricityPlanのインスタンスの配列で返す。
  def call(electricity_plans_data)
    electricity_plans_data.map do |provider_data|
      provider = Provider.new(provider_data['provider_name'])
      provider_data['plans'].map do |plan_data|
        ElectricityPlan.new(
          provider,
          plan_data['plan_name'],
          BasicChargeTable.new(plan_data['basic_charge']),
          EnergyUseChargeTable.new(
            build_energy_use_charge_unit_prices(plan_data['enery_use_charge'])
          )
        )
      end
    end.flatten
  end

  private

  def build_energy_use_charge_unit_prices(energy_use_charges)
    energy_use_charges.map do |charge|
      range = charge['range'].first..(charge['range'].last || Float::INFINITY)
      EnergyUseChargeUnitPrice.new(range, charge['rate'])
    end
  end
end
