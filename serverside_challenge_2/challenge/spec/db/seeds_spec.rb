describe 'Seedデータ作成', type: :helper do
  let(:basic_prices_csv_path) { Rails.root.join('db/seeds/basic_prices.csv') }
  let(:measured_rates_csv_path) { Rails.root.join('db/seeds/measured_rates.csv') }

  before do
    Rails.application.load_seed
  end

  it 'Providerが作成されること' do
    CSV.foreach(basic_prices_csv_path, headers: true) do |row|
      provider = Provider.find_by!(name: row[0])
      expect(provider).to be_present
    end
  end

  it 'Planが作成されること' do
    CSV.foreach(basic_prices_csv_path, headers: true) do |row|
      provider = Provider.find_by!(name: row[0])
      plan = Plan.find_by!(name: row[1], provider: provider)
      expect(plan).to be_present
    end
  end

  it '基本料金が作成されること' do
    CSV.foreach(basic_prices_csv_path, headers: true) do |row|
      plan = Plan.find_by!(name: row[1])
      basic_price = BasicPrice.find_by!(amperage: row[2], plan: plan)
      expect(basic_price).to be_present

      expect(basic_price.price).to eq row[3].to_f
    end
  end

  it '従量料金が作成されること' do
    CSV.foreach(measured_rates_csv_path, headers: true) do |row|
      plan = Plan.find_by!(name: row[1])

      usage = row[2].split('-').map(&:to_i)
      electricity_usage_min = usage[0]
      electricity_usage_max = usage[1] || MeasuredRate::MAX_SMALL_INT_VALUE
      measured_rate = MeasuredRate.find_by!(electricity_usage_min: electricity_usage_min,
                                            electricity_usage_max: electricity_usage_max,
                                            plan: plan)
      expect(measured_rate).to be_present
      expect(measured_rate.price).to eq row[3].to_f
    end
  end
end
