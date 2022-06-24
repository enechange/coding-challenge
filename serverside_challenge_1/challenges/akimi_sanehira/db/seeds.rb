require 'csv'

# provider data
CSV.foreach('db/seeds/csv/providers.csv', headers: true) do |row|
  Provider.create(
    name: row['name'],
  )
end