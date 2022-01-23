# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

companies = ['東京電力エナジーパートナー', 'Loopでんき', '東京ガス', 'JXTGでんき']
plans = ['従量電灯B', 'おうちプラン', 'ずっとも電気1', '従量電灯Bたっぷりプラン']
companies.each_with_index do |name, i|
    company = Company.create!(name: name)
    Plan.create!(company: company, name: plans[i])
end
