require "csv"

count = 0
CSV.foreach('db/csv/development/electric_power_provider.csv', headers: true) do |row|
  ElectricPowerProvider.create!(id: count += 1,
                                name: row['name'])
end

count = 0
CSV.foreach('db/csv/development/electricity_rate_plan.csv', headers: true) do |row|
  ElectricityRatePlan.create!(id: count += 1,
                              name: row['name'],
                              electric_power_provider_id: row['electric_power_provider_id'])
end

CSV.foreach('db/csv/development/basic_charge.csv', headers: true) do |row|
  BasicCharge.create!(contract_amperage: row['contract_amperage'],
                      electricity_rate_plan_id: row['electricity_rate_plan_id'],
                      charge_unit_price: row['charge_unit_price'])
end

CSV.foreach('db/csv/development/usage_charge.csv', headers: true) do |row|
  UsageCharge.create!(charge_unit_price: row['charge_unit_price'],
                      minimum_usage: row['min_usage'],
                      max_usage: row['max_usage'],
                      electricity_rate_plan_id: row['electricity_rate_plan_id'])
end
