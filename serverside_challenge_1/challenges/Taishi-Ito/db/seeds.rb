require "csv"

puts "start create company"
CSV.foreach('db/seeds/company.csv', headers: true) do |row|
  Api::V1::Company.create(
    id: row[0],
    name: row[1]
  )
end
puts "fin create company"

puts "start create plan"
CSV.foreach('db/seeds/plan.csv', headers: true) do |row|
  Api::V1::Plan.create(
    id: row[0],
    api_v1_company_id: row[1],
    name: row[2]
  )
end
puts "fin create plan"

puts "start create basic_charges"
CSV.foreach('db/seeds/basic_charges.csv', headers: true) do |row|
  Api::V1::BasicCharge.create(
    api_v1_plan_id: row[0],
    ampere: row[1],
    charge: row[2]
  )
end
puts "fin create basic_charges"

puts "start create usage_charges"
CSV.foreach('db/seeds/usage_charges.csv', headers: true) do |row|
  Api::V1::UsageCharge.create(
    api_v1_plan_id: row[0],
    from_khw: row[1],
    to_khw: row[2],
    charge: row[3],
    stacked_charge: row[4]
  )
end
puts "fin create usage_charges"
