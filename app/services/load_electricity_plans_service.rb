# frozen_string_literal: true

require 'yaml'

class LoadElectricityPlansService
  def call(file_path = 'config/electricity_plans.yml')
    electricity_plans_data = load_electricity_plans_data(file_path)
    build_electricity_plans(electricity_plans_data)
  end

  private

  def load_electricity_plans_data(file_path)
    full_path = Rails.root.join(file_path)

    raise "ファイルが存在しません: #{file_path}" unless File.exist?(full_path)

    raise "ファイルが空です: #{file_path}" if File.zero?(full_path)

    YAML.load_file(full_path)
  end

  def build_electricity_plans(data)
    data.map do |provider_data|
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

  def build_energy_use_charge_unit_prices(energy_use_charges)
    energy_use_charges.map do |charge|
      range = charge['range'].first..(charge['range'].last || Float::INFINITY)
      EnergyUseChargeUnitPrice.new(range, charge['rate'])
    end
  end
end
