require "csv"

CSV.foreach('db/initial_data_csv/electric_power_provider.csv', headers: true) do |row|
  electric_power_provider = ElectricPowerProvider.find_or_initialize_by(name: row['name'])
  electric_power_provider.save!
end

CSV.foreach('db/initial_data_csv/electricity_rate_plan.csv', headers: true) do |row|
  electricity_rate_plan = ElectricityRatePlan.find_or_initialize_by(name: row['name'],
                                                                    electric_power_provider_id: row['electric_power_provider_id'])
  electricity_rate_plan.save!
end

CSV.foreach('db/initial_data_csv/basic_charge.csv', headers: true) do |row|
  base_charge = BasicCharge.find_or_initialize_by(contract_amperage: row['contract_amperage'],
                                                  electricity_rate_plan_id: row['electricity_rate_plan_id'])
  base_charge.assign_attributes(charge_unit_price: row['charge_unit_price'])
  base_charge.save!
end

CSV.foreach('db/initial_data_csv/usage_charge.csv', headers: true) do |row|
  usage_charge = UsageCharge.find_or_initialize_by(minimum_usage: row['min_usage'],
                                                   max_usage: row['max_usage'],
                                                   electricity_rate_plan_id: row['electricity_rate_plan_id'])
  usage_charge.assign_attributes(charge_unit_price: row['charge_unit_price'])
  usage_charge.save!
end
