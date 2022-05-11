require "csv"

CSV.foreach('db/csv/providers.csv', headers: true) do |row|
	Provider.create(
		name: row['name']
	)
end

CSV.foreach('db/csv/plans.csv', headers: true) do |row|
	Plan.create(
		provider_id: row['provider_id'],
		name: row['name']
	)
end

CSV.foreach('db/csv/base_fees.csv', headers: true) do |row|
	BaseFee.create(
		plan_id: row['plan_id'],
		ampere: row['ampere'],
		base_fee: row['base_fee']
	)
end

CSV.foreach('db/csv/usage_fees.csv', headers: true) do |row|
	UsageFee.create(
		plan_id: row['plan_id'],
		min_usage: row['min_usage'],
		max_usage: row['max_usage'],
		unit_usage_fee: row['unit_usage_fee']
	)
end
