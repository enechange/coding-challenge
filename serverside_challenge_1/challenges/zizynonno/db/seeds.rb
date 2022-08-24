require 'csv'

CSV.foreach('db/csv/electric_power_companies.csv', headers: true) do |row|
  ElectricPowerCompany.create(
    name: row['name']
  )
end

CSV.foreach('db/csv/electricity_plans.csv', headers: true) do |row|
  ElectricityPlan.create(
    electric_power_company_id: row['electric_power_company_id'],
    name: row['name']
  )
end

CSV.foreach('db/csv/basic_rates.csv', headers: true) do |row|
  BasicRate.create(
    electricity_plan_id: row['electricity_plan_id'],
    ampere: row['ampere'],
    price: row['price']
  )
end

CSV.foreach('db/csv/meter_rates.csv', headers: true) do |row|
  MeterRate.create(
    electricity_plan_id: row['electricity_plan_id'],
    min_usage: row['min_usage'],
    max_usage: row['max_usage'],
    price: row['price']
  )
end