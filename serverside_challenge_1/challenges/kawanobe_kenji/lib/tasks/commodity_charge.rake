require "csv"

namespace :commodity_charge do
  csv_dir = Rails.root.join("lib/assets")
  directory csv_dir

  desc "Import commodity_charge from csv"
  task import: :environment do
    puts "== START == commodity_charge のデータ追加"
    ActiveRecord::Base.transaction do
      csv_file = "#{csv_dir}/commodity_charge.csv"
      CSV.foreach(csv_file, headers: true, skip_blanks: true).with_index do |row, index|
        commodity_charge = CommodityCharge.find_or_initialize_by(plan_id: row["plan_id"], kwh_from: row["kwh_from"],
                                                                 kwh_to: row["kwh_to"], charge: row["charge"])
        raise "CommodityCharge の保存に失敗しました（#{index + 2}行目）。" unless commodity_charge.save
      end
    end
    puts "== END == commodity_charge のデータ追加"
  end
end
