# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'

CSV.foreach('./app/assets/provider.csv', headers: true) do |r|
  Provider.where(name: r['name'], plan_name: r['plan_name']).first_or_create!(
    name: r['name'],
    plan_name: r['plan_name']
  )
end

CSV.foreach('./app/assets/basic_rate.csv', headers: true) do |r|
  BasicRate.where(provider_id: r['provider_id'], ampere: r['ampere'], price: r['price']).first_or_create!(
    provider_id: r['provider_id'],
    ampere: r['ampere'],
    price: r['price']
  )
end

CSV.foreach('./app/assets/pay_per_use_rate.csv', headers: true) do |r|
  PayPerUseRate.where(provider_id: r['provider_id'], unit_price: r['unit_price'], min_electricity_usage: r['min_electricity_usage'], max_electricity_usage: r['max_electricity_usage']).first_or_create!(
    provider_id: r['provider_id'],
    unit_price: r['unit_price'],
    min_electricity_usage: r['min_electricity_usage'],
    max_electricity_usage: r['max_electricity_usage']
  )
end