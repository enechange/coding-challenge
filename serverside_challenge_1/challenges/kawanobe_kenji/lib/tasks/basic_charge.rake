require "csv"

namespace :basic_charge do
  csv_dir = Rails.root.join("lib/assets")
  directory csv_dir

  desc "Import basic_charge from csv"
  task import: :environment do
    puts "== START == basic_charge のデータ追加"
    ActiveRecord::Base.transaction do
      csv_file = "#{csv_dir}/basic_charge.csv"
      CSV.foreach(csv_file, headers: true, skip_blanks: true).with_index do |row, index|
        basic_charge = BasicCharge.find_or_initialize_by(plan_id: row["plan_id"], ampere: row["ampere"],
                                                         charge: row["charge"])
        raise "BasicCharge の保存に失敗しました（#{index + 2}行目）。" unless basic_charge.save
      end
    end
    puts "== END == basic_charge のデータ追加"
  end
end
