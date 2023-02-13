require "csv"

namespace :provider do
  csv_dir = Rails.root.join("lib/assets")
  directory csv_dir

  desc "Import provider from csv"
  task import: :environment do
    puts "== START == provider のデータ追加"
    ActiveRecord::Base.transaction do
      csv_file = "#{csv_dir}/provider.csv"
      CSV.foreach(csv_file, headers: true, skip_blanks: true).with_index do |row, index|
        provider = Provider.find_or_initialize_by(name: row["name"])
        raise "Provider の保存に失敗しました（#{index + 2}行目）。" unless provider.save
      end
    end
    puts "== END == provider のデータ追加"
  end
end
