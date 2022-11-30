require 'csv'

namespace :import do
  desc "Import plan data from csv"

  task plans: :environment do
    path = File.join Rails.root, "db/csv/plans.csv"
    puts "path: #{path}"
    list = []
    CSV.foreach(path, headers: true) do |row|
      list << {
        id: row["id"],
        name: row["name"],
        provider_name: row["provider_name"],
      }
    end

    begin
      Plan.create!(list)
      puts "completed!"
    rescue
      puts "error occurred!"
    end
  end

  task basic_prices: :environment do
    path = File.join Rails.root, "db/csv/basic_prices.csv"
    puts "path: #{path}"
    list = []
    CSV.foreach(path, headers: true) do |row|
      list << {
        id: row["id"],
        plan_id: row["plan_id"],
        ampere: row["ampere"],
        price: row["price"],
      }
    end

    begin
      BasicPrice.create!(list)
      puts "completed!"
    rescue
      puts "error occurred!"
    end
  end

  task unit_prices: :environment do
    path = File.join Rails.root, "db/csv/unit_prices.csv"
    puts "path: #{path}"
    list = []
    CSV.foreach(path, headers: true) do |row|
      list << {
        id: row["id"],
        plan_id: row["plan_id"],
        lower_usage_limit: row["lower_usage_limit"],
        upper_usage_limit: row["upper_usage_limit"] == "" ? nil : row["upper_usage_limit"],
        price: row["price"],
      }
    end

    begin
      UnitPrice.create!(list)
      puts "completed!"
    rescue
      puts "error occurred!"
    end
  end

end
