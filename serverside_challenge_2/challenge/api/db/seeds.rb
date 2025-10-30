Provider.import_from_csv!(Rails.root.join('db/csv/providers.csv'))
Plan.import_from_csv!(Rails.root.join('db/csv/plans.csv'))
BasicCharge.import_from_csv!(Rails.root.join('db/csv/basic_charges.csv'))
UsageCharge.import_from_csv!(Rails.root.join('db/csv/usage_charges.csv'))
puts 'seed完了'
