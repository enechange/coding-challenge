# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'

CSV.foreach('./app/assets/provider.csv', headers: true) do |r|
  provider = Provider.find(r['id'])
  if provider.present?
    provider.update!(name: r['name'], plan_name: r['plan_name'])
  else
    Provider.create!(id: r['id'], name: r['name'], plan_name: r['plan_name'])
  end
end

CSV.foreach('./app/assets/basic_rate.csv', headers: true) do |r|
  basic_rate = BasicRate.find(r['id'])
  if basic_rate.present?
    basic_rate.update!(provider_id: r['provider_id'], ampere: r['ampere'], price: r['price'])
  else
    BasicRate.create!(id: r['id'], provider_id: r['provider_id'], ampere: r['ampere'], price: r['price'])
  end
end

CSV.foreach('./app/assets/pay_per_use_rate.csv', headers: true) do |r|
  pay_per_use_rate = PayPerUseRate.find(r['id'])
  if pay_per_use_rate.present?
    pay_per_use_rate.update!(
      provider_id: r['provider_id'],
      unit_price: r['unit_price'],
      min_electricity_usage: r['min_electricity_usage'],
      max_electricity_usage: r['max_electricity_usage']
    )
  else
    PayPerUseRate.create!(
      id: r['id'],
      provider_id: r['provider_id'],
      unit_price: r['unit_price'],
      min_electricity_usage: r['min_electricity_usage'],
      max_electricity_usage: r['max_electricity_usage']
    )
  end
end