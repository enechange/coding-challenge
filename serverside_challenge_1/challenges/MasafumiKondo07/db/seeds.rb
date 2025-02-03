require "csv"

CSV.foreach('db/master_data_files/companies.csv', headers: true) do |row|
  Company.create(
    name: row['name']
  )
end

CSV.foreach('db/master_data_files/plans.csv', headers: true) do |row|
  Plan.create(
    company_id: row['company_id'],
    name: row['name']
  )
end

CSV.foreach('db/master_data_files/basic_charges.csv', headers: true) do |row|
  BasicCharge.create(
    plan_id: row['plan_id'],
    ampere: row['ampere'],
    unit: row['unit'],
    price: row['price']
  )
end

CSV.foreach('db/master_data_files/electricity_fees.csv', headers: true) do |row|
  ElectricityFee.create(
    plan_id: row['plan_id'],
    classification_min: row['classification_min'],
    classification_max: row['classification_max'],
    unit: row['unit'],
    price: row['price']
  )
end