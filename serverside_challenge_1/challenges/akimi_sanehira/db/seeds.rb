require 'csv'

# provider data
CSV.foreach('db/seeds/csv/providers.csv', headers: true) do |row|
  Provider.create(
    name: row['name'],
  )
end

CSV.foreach('db/seeds/csv/plans.csv', headers: true) do |row|
  Plan.create(
    provider_id: row['provider_id'],
    name: row['name'],
  )
end

CSV.foreach('db/seeds/csv/base_fees.csv', headers: true) do |row|
  BasicFee.create(
    plan_id: row['plan_id'],
    ampere: row['ampere'],
    base_fee: row['base_fee'],
  )
end
