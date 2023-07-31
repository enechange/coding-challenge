# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'

ApplicationRecord.transaction do
  CSV.foreach('./app/assets/provider.csv', headers: true) do |r|
    provider = Provider.find_by(id: r['id'])
    if provider.present?
      provider.update!(name: r['name'])
    else
      Provider.create!(id: r['id'], name: r['name'])
    end
  end

  CSV.foreach('./app/assets/plan.csv', headers: true) do |r|
    plan = Plan.find_by(id: r['id'])
    provider = Provider.find_by(name: r['provider_name'])
    if plan.present?
      plan.update!(name: r['name'], provider_id: provider.id)
    else
      Plan.create!(id: r['id'], provider_id: provider.id, name: r['name'])
    end
  end

  CSV.foreach('./app/assets/basic_rate.csv', headers: true) do |r|
    basic_rate = BasicRate.find_by(id: r['id'])
    plan = Plan.find_by(name: r['plan_name'])
    if basic_rate.present?
      basic_rate.update!(plan_id: plan.id, ampere: r['ampere'], price: r['price'])
    else
      BasicRate.create!(id: r['id'], plan_id: plan.id, ampere: r['ampere'], price: r['price'])
    end
  end

  CSV.foreach('./app/assets/pay_per_use_rate.csv', headers: true) do |r|
    pay_per_use_rate = PayPerUseRate.find_by(id: r['id'])
    plan = Plan.find_by(name: r['plan_name'])
    if pay_per_use_rate.present?
      pay_per_use_rate.update!(
        plan_id: plan.id,
        unit_price: r['unit_price'],
        min_electricity_usage: r['min_electricity_usage'],
        max_electricity_usage: r['max_electricity_usage']
      )
    else
      PayPerUseRate.create!(
        id: r['id'],
        plan_id: plan.id,
        unit_price: r['unit_price'],
        min_electricity_usage: r['min_electricity_usage'],
        max_electricity_usage: r['max_electricity_usage']
      )
    end
  end
rescue StandardError => e
  pp e
end