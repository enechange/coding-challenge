# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

p '==================== provider create ===================='

Provider.create!(
  [
    { name: '東京電力エナジーパートナー' },
    { name: '東京ガス' },
    { name: 'Looopでんき' }
  ]
)

p '==================== power_supply_plan create ===================='

provider = Provider.find(1)
plans = provider.power_supply_plans.new(
  [
    { name: '従量電灯B' },
    { name: 'スタンダードS' }
  ]
)
plans.each(&:save)

Provider.find(2).power_supply_plans.create!(name: 'ずっとも電気1')
Provider.find(3).power_supply_plans.create!(name: 'おうちプラン')

p '==================== basic_charge create ===================='

seed_data = [
  { index: 1, data: [
    { amp: 10, price: 286.00 },
    { amp: 15, price: 429.00 },
    { amp: 20, price: 572.00 },
    { amp: 30, price: 858.00 },
    { amp: 40, price: 1144.00 },
    { amp: 50, price: 1430.00 },
    { amp: 60, price: 1716.00 }
  ] },
  { index: 2, data: [
    { amp: 10, price: 311.75 },
    { amp: 15, price: 467.63 },
    { amp: 20, price: 623.50 },
    { amp: 30, price: 935.25 },
    { amp: 40, price: 1247.00 },
    { amp: 50, price: 1558.75 },
    { amp: 60, price: 1870.50 }
  ] },
  { index: 3, data: [
    { amp: 30, price: 858.00 },
    { amp: 40, price: 1144.00 },
    { amp: 50, price: 1430.00 },
    { amp: 60, price: 1716.00 }
  ] },
  { index: 4, data: [
    { amp: 10, price: 0.00 },
    { amp: 15, price: 0.00 },
    { amp: 20, price: 0.00 },
    { amp: 30, price: 0.00 },
    { amp: 40, price: 0.00 },
    { amp: 50, price: 0.00 },
    { amp: 60, price: 0.00 }
  ] }
]
seed_data.each do |d|
  plan = PowerSupplyPlan.find(d[:index])
  basic_charges = plan.basic_charges.new(d[:data])
  basic_charges.each(&:save)
end

p '==================== meter_ratecharge create ===================='

seed_data = [
  { index: 1, data: [
    { min_meter_rate: 0, max_meter_rate: 120, price: 19.88 },
    { min_meter_rate: 121, max_meter_rate: 300, price: 26.48 },
    { min_meter_rate: 301, max_meter_rate: nil, price: 30.57 }
  ] },
  { index: 2, data: [
    { min_meter_rate: 0, max_meter_rate: 120, price: 29.80 },
    { min_meter_rate: 121, max_meter_rate: 300, price: 36.40 },
    { min_meter_rate: 301, max_meter_rate: nil, price: 40.49 }
  ] },
  { index: 3, data: [
    { min_meter_rate: 0, max_meter_rate: 140, price: 23.67 },
    { min_meter_rate: 141, max_meter_rate: 350, price: 23.88 },
    { min_meter_rate: 351, max_meter_rate: nil, price: 26.41 }
  ] },
  { index: 4, data: [
    { min_meter_rate: 0, max_meter_rate: nil, price: 28.80 }
  ] }
]

seed_data.each do |d|
  plan = PowerSupplyPlan.find(d[:index])
  basic_charges = plan.meter_rate_charges.new(d[:data])
  basic_charges.each(&:save)
end
