# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# company
Company.create(id: 1, provider_name: "東京電力エナジーパートナー", plan_name: "従量電灯B")
Company.create(id: 2, provider_name: "東京ガス株式会社", plan_name: "ずっとも電気1")
Company.create(id: 3, provider_name: "Loopでんき", plan_name: "おうちプラン")
Company.create(id: 4, provider_name: "JXTGでんき", plan_name: "従量電灯B　たっぷりプラン")

# basic_charge
BasicCharge.create(ampere: 10, fee: 286.00, company_id: 1)
BasicCharge.create(ampere: 15, fee: 429.00, company_id: 1)
BasicCharge.create(ampere: 20, fee: 572.00, company_id: 1)
BasicCharge.create(ampere: 30, fee: 858.00, company_id: 1)
BasicCharge.create(ampere: 40, fee: 1144.00, company_id: 1)
BasicCharge.create(ampere: 50, fee: 1430.00, company_id: 1)
BasicCharge.create(ampere: 60, fee: 1716.00, company_id: 1)
BasicCharge.create(ampere: 30, fee: 858.00, company_id: 2)
BasicCharge.create(ampere: 40, fee: 1144.00, company_id: 2)
BasicCharge.create(ampere: 50, fee: 1430.00, company_id: 2)
BasicCharge.create(ampere: 60, fee: 1716.00, company_id: 2)
BasicCharge.create(ampere: 999, fee: 0.00, company_id: 3)
BasicCharge.create(ampere: 30, fee: 858.00, company_id: 4)
BasicCharge.create(ampere: 40, fee: 1144.00, company_id: 4)
BasicCharge.create(ampere: 50, fee: 1430.00, company_id: 4)
BasicCharge.create(ampere: 60, fee: 1716.00, company_id: 4)

# usage_charge
UsageCharge.create(prev_tier: 0, tier: 120, fee: 19.88, company_id: 1)
UsageCharge.create(prev_tier: 120, tier: 300, fee: 26.48, company_id: 1)
UsageCharge.create(prev_tier: 300, tier: 999999, fee: 30.57, company_id: 1)
UsageCharge.create(prev_tier: 0, tier: 140, fee: 23.67, company_id: 2)
UsageCharge.create(prev_tier: 140, tier: 350, fee: 23.88, company_id: 2)
UsageCharge.create(prev_tier: 350, tier: 999999, fee: 26.41, company_id: 2)
UsageCharge.create(prev_tier: 0, tier: 999999, fee: 26.40, company_id: 3)
UsageCharge.create(prev_tier: 0, tier: 120, fee: 19.88, company_id: 4)
UsageCharge.create(prev_tier: 120, tier: 300, fee: 26.48, company_id: 4)
UsageCharge.create(prev_tier: 300, tier: 600, fee: 25.08, company_id: 4)
UsageCharge.create(prev_tier: 600, tier: 999999, fee: 26.15, company_id: 4)