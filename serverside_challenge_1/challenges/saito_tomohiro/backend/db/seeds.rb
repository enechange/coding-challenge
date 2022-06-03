require 'csv'

CSV.foreach('db/csv/providers.csv', headers: true) do |row|
  Provider.create(
    name: row['name']
  )
end

CSV.foreach('db/csv/plans.csv', headers: true) do |row|
  Plan.create(
    provider_id: row['provider_id'],
    name: row['name']
  )
end

CSV.foreach('db/csv/base_charges.csv', headers: true) do |row|
  BaseCharge.create(
    plan_id: row['plan_id'],
    ampere: row['ampere'],
    base_charge: row['base_charge']
  )
end

CSV.foreach('db/csv/per_use_charges.csv', headers: true) do |row|
  PerUseCharge.create(
    plan_id: row['plan_id'],
    min_usage: row['min_usage'],
    max_usage: row['max_usage'],
    per_use_charge: row['per_use_charge']
  )
end
