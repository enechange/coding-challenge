require 'csv'

BasicPrice.delete_all
CSV.foreach(Rails.root.join('db/seeds/basic_prices.csv'), headers: true) do |row|
  company = ElectricPowerCompany.find_or_create_by(name: row[0])
  plan = company.plans.find_or_create_by(name: row[1])
  # データ投入
  plan.basic_prices.create!(amperage: row[2], price: row[3])
end

MeasuredRate.delete_all
CSV.foreach(Rails.root.join('db/seeds/measured_rates.csv'), headers: true) do |row|
  company = ElectricPowerCompany.find_or_create_by(name: row[0])
  plan = company.plans.find_or_create_by(name: row[1])
  electricity_usages = row[2].split('-')
  # データ投入
  plan.measured_rates.create!(electricity_usage_min: electricity_usages[0].to_i,
                               electricity_usage_max: electricity_usages[1]&.to_i,
                               price: row[3])
end
