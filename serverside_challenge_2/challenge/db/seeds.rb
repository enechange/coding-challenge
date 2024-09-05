# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'

# TODO: ただ大量にデータを追加する場合は、これだと遅いので、違う形式に変更すること
# MEMO: 画面化すれば、CSV での読み込みもそこまで使うことはなくなるため、画面化の時期に応じて対応を早める (issue も必要に応じて立てること)
# すぐにできる対応としては、この記事とかは役立ちそう https://techblog.lclco.com/entry/2019/07/31/180000
CSV.foreach('db/seed_data/providers.csv', headers: :first_row) do |line|
  Provider.upsert({id: line[0], name: line[1]}, unique_by: :id)
end

CSV.foreach('db/seed_data/plans.csv', headers: :first_row) do |line|
  Plan.upsert({id: line[0], name: line[1], provider_id: line[2], usage_tier: line[3]}, unique_by: :id)
end

CSV.foreach('db/seed_data/electricity_usages.csv', headers: :first_row) do |line|
  ElectricityUsage.upsert({id: line[0], from: line[1], to: line[2], unit_price: line[3], plan_id: line[4]}, unique_by: :id)
end

CSV.foreach('db/seed_data/basic_monthly_fees.csv', headers: :first_row) do |line|
  BasicMonthlyFee.upsert({id: line[0], contract_amperage: line[1], price: line[2], plan_id: line[3]}, unique_by: :id)
end
