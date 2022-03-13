require 'csv'

import = lambda do |klass, file_path|
  options = {
    encoding: "UTF-8",
    headers: true,
    header_converters: klass.csv_header_converters
  }

  CSV.read(file_path, **options).each_slice(1000) do |rows|
    values = rows.map(&:to_h).map { |row| klass.new(row) }
    klass.import! values, validate: true
  end
end

ActiveRecord::Base.transaction do
  BasicFee.destroy_all
  UsageCharge.destroy_all
  Plan.destroy_all
  Company.destroy_all
  
  import.(Company, Rails.root.join('db', 'data', 'Companies.csv'))
  import.(Plan, Rails.root.join('db', 'data', 'Plans.csv'))
  import.(BasicFee, Rails.root.join('db', 'data', 'BasicFees.csv'))
  import.(UsageCharge, Rails.root.join('db', 'data', 'UsageCharges.csv'))
end