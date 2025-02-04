# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

providers = [
  { name: '東京電力エナジーパートナー' },
  { name: '東京ガス' },
  { name: 'Looopでんき' }
]

providers.each do |provider|
  Provider.find_or_create_by(provider)
end

plans = [
  { name: '従量電灯B', provider: Provider.find_by(name: '東京電力エナジーパートナー') },
  { name: 'スタンダードS', provider: Provider.find_by(name: '東京電力エナジーパートナー') },
  { name: 'ずっとも電気1', provider: Provider.find_by(name: '東京ガス') },
  { name: 'おうちプラン', provider: Provider.find_by(name: 'Looopでんき') }
]

plans.each do |plan|
  Plan.find_or_create_by(plan)
end

basic_rates = [
  # 東京電力エナジーパートナー / 従量電灯B
  { plan: '従量電灯B', ampere: 10, price: 286.00 },
  { plan: '従量電灯B', ampere: 15, price: 429.00 },
  { plan: '従量電灯B', ampere: 20, price: 572.00 },
  { plan: '従量電灯B', ampere: 30, price: 858.00 },
  { plan: '従量電灯B', ampere: 40, price: 1144.00 },
  { plan: '従量電灯B', ampere: 50, price: 1430.00 },
  { plan: '従量電灯B', ampere: 60, price: 1716.00 },
  # 東京電力エナジーパートナー / スタンダードS
  { plan: 'スタンダードS', ampere: 10, price: 311.75 },
  { plan: 'スタンダードS', ampere: 15, price: 467.63 },
  { plan: 'スタンダードS', ampere: 20, price: 623.50 },
  { plan: 'スタンダードS', ampere: 30, price: 935.25 },
  { plan: 'スタンダードS', ampere: 40, price: 1247.00 },
  { plan: 'スタンダードS', ampere: 50, price: 1558.75 },
  { plan: 'スタンダードS', ampere: 60, price: 1870.50 },
  # 東京ガス / ずっとも電気1
  { plan: 'ずっとも電気1', ampere: 30, price: 858.00 },
  { plan: 'ずっとも電気1', ampere: 40, price: 1144.00 },
  { plan: 'ずっとも電気1', ampere: 50, price: 1430.00 },
  { plan: 'ずっとも電気1', ampere: 60, price: 1716.00 },
  # Looopでんき / おうちプラン
  { plan: 'おうちプラン', ampere: 10, price: 0.00 },
  { plan: 'おうちプラン', ampere: 15, price: 0.00 },
  { plan: 'おうちプラン', ampere: 20, price: 0.00 },
  { plan: 'おうちプラン', ampere: 30, price: 0.00 },
  { plan: 'おうちプラン', ampere: 40, price: 0.00 },
  { plan: 'おうちプラン', ampere: 50, price: 0.00 },
  { plan: 'おうちプラン', ampere: 60, price: 0.00 }
]

basic_rates.each do |rate|
  plan = Plan.find_by(name: rate[:plan])
  BasicRate.find_or_create_by(plan: plan, ampere: rate[:ampere], price: rate[:price])
end

usage_rates = [
  # 東京電力エナジーパートナー / 従量電灯B
  { plan: '従量電灯B', min_kwh: 0, max_kwh: 120, price_per_kwh: 19.88 },
  { plan: '従量電灯B', min_kwh: 121, max_kwh: 300, price_per_kwh: 26.48 },
  { plan: '従量電灯B', min_kwh: 301, max_kwh: nil, price_per_kwh: 30.57 },
  # 東京電力エナジーパートナー / スタンダードS
  { plan: 'スタンダードS', min_kwh: 0, max_kwh: 120, price_per_kwh: 29.80 },
  { plan: 'スタンダードS', min_kwh: 121, max_kwh: 300, price_per_kwh: 36.40 },
  { plan: 'スタンダードS', min_kwh: 301, max_kwh: nil, price_per_kwh: 40.49 },
  # 東京ガス / ずっとも電気1
  { plan: 'ずっとも電気1', min_kwh: 0, max_kwh: 140, price_per_kwh: 23.67 },
  { plan: 'ずっとも電気1', min_kwh: 141, max_kwh: 350, price_per_kwh: 23.88 },
  { plan: 'ずっとも電気1', min_kwh: 351, max_kwh: nil, price_per_kwh: 26.41 },
  # Looopでんき / おうちプラン
  { plan: 'おうちプラン', min_kwh: 0, max_kwh: nil, price_per_kwh: 28.8 }
]

usage_rates.each do |rate|
  plan = Plan.find_by(name: rate[:plan])
  UsageRate.find_or_create_by(plan: plan, min_kwh: rate[:min_kwh], max_kwh: rate[:max_kwh], price_per_kwh: rate[:price_per_kwh])
end
