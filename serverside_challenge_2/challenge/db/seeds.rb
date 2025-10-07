# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'
csv_dir = Rails.root.join("db", "seeds")

seeds = [
  { file: "providers.csv", model: Provider, attributes: %w(code name) },
  { file: "plans.csv", model: Plan, attributes: %w(code provider_code name) },
  { file: "basic_fees.csv", model: BasicFee, attributes: %w(code plan_code ampere fee) },
  { file: "usage_charges.csv", model: UsageCharge, attributes: %w(code plan_code usage_lower usage_upper unit_price) }
]

ActiveRecord::Base.transaction do
  seeds.each do |seed|
    CSV.foreach(csv_dir.join(seed[:file]), headers: true) do |row|
      attributes = seed[:attributes].map { |attr| [attr.to_sym, row[attr]] }.to_h
      seed[:model].create!(attributes)
    end
  end
end
