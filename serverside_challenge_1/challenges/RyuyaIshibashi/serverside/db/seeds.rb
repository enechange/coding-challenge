# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

BasicFee.destroy_all
UsageCharge.destroy_all
Plan.destroy_all
Company.destroy_all

companies = ['東京電力エナジーパートナー', 'Loopでんき', '東京ガス', 'JXTGでんき']
plans = ['従量電灯B', 'おうちプラン', 'ずっとも電気1', '従量電灯Bたっぷりプラン']
companies.each_with_index do |name, i|
  company = Company.create!(name: name)
  plan = Plan.create!(company: company, name: plans[i])

  case i
  when 0
    BasicFee.create!(plan: plan, ampare: '10.00', fee: '286.00')
    BasicFee.create!(plan: plan, ampare: '15.00', fee: '429.00')
    BasicFee.create!(plan: plan, ampare: '20.00', fee: '572.00')
    BasicFee.create!(plan: plan, ampare: '30.00', fee: '858.00')
    BasicFee.create!(plan: plan, ampare: '40.00', fee: '1144.00')
    BasicFee.create!(plan: plan, ampare: '50.00', fee: '1430.00')
    BasicFee.create!(plan: plan, ampare: '60.00', fee: '1716.00')

    UsageCharge.create!(plan: plan, from: '0.00', to: '120.00', unit_price: '19.88')
    UsageCharge.create!(plan: plan, from: '120.00', to: '300.00', unit_price: '26.48')
    UsageCharge.create!(plan: plan, from: '300.00', to: nil, unit_price: '30.57')
  when 1
    BasicFee.create!(plan: plan, ampare: '10.00', fee: '0.00')
    BasicFee.create!(plan: plan, ampare: '15.00', fee: '0.00')
    BasicFee.create!(plan: plan, ampare: '20.00', fee: '0.00')
    BasicFee.create!(plan: plan, ampare: '30.00', fee: '0.00')
    BasicFee.create!(plan: plan, ampare: '40.00', fee: '0.00')
    BasicFee.create!(plan: plan, ampare: '50.00', fee: '0.00')
    BasicFee.create!(plan: plan, ampare: '60.00', fee: '0.00')

    UsageCharge.create!(plan: plan, from: '0.00', to: nil, unit_price: '26.40')
  when 2
    BasicFee.create!(plan: plan, ampare: '30.00', fee: '858.00')
    BasicFee.create!(plan: plan, ampare: '40.00', fee: '1144.00')
    BasicFee.create!(plan: plan, ampare: '50.00', fee: '1430.00')
    BasicFee.create!(plan: plan, ampare: '60.00', fee: '1716.00')

    UsageCharge.create!(plan: plan, from: '0.00', to: '140.00', unit_price: '23.67')
    UsageCharge.create!(plan: plan, from: '140.00', to: '350.00', unit_price: '23.88')
    UsageCharge.create!(plan: plan, from: '350.00', to: nil, unit_price: '26.41')
  when 3
    BasicFee.create!(plan: plan, ampare: '30.00', fee: '858.00')
    BasicFee.create!(plan: plan, ampare: '40.00', fee: '1144.00')
    BasicFee.create!(plan: plan, ampare: '50.00', fee: '1430.00')
    BasicFee.create!(plan: plan, ampare: '60.00', fee: '1716.80')

    UsageCharge.create!(plan: plan, from: '0.00', to: '120.00', unit_price: '19.88')
    UsageCharge.create!(plan: plan, from: '120.00', to: '300.00', unit_price: '26.48')
    UsageCharge.create!(plan: plan, from: '300.00', to: '600.00', unit_price: '25.08')
    UsageCharge.create!(plan: plan, from: '600.00', to: nil, unit_price: '26.15')
  end
end
