require 'rails_helper'

RSpec.describe Utils::EnergyPrice do
  let(:file_path) { Rails.root.join('spec/files/energy_prices_sample.csv') }
  let(:csv_data) { CSV.read(file_path, headers: true) }

  context 'each_prices' do
    it '各プランの料金' do
      prices = described_class.each_prices(csv_data, 20, 150)
      expect(prices).to be_present
      expect(prices.size).to eq 4

      plan1 = prices[0]
      expect(plan1[:provider_name]).to eq 'サンプル電力'
      expect(plan1[:plan_name]).to eq '従量電灯B'
      basic_fee = csv_data.find {|r| r['plan_name'] == 'juryo-dento-x' && r['amperes_up_to'] == '20' }
      cons_fee = csv_data.find {|r| r['plan_name'] == 'juryo-dento-x' && r['amount_greater_than'] == '120' }
      expect(plan1[:price]).to eq basic_fee['price'].to_f + cons_fee['price'].to_f * 150

      plan2 = prices[1]
      expect(plan2[:provider_name]).to eq 'テストでんき'
      expect(plan2[:plan_name]).to eq 'おうちプラン'
      expect(plan2[:plan_name]).to be_present

      plan3 = prices[2]
      expect(plan3[:provider_name]).to eq '試験ガス株式会社'
      expect(plan3[:plan_name]).to eq 'ずっとも電気1'
      expect(plan3[:plan_name]).to be_present

      plan4 = prices[3]
      expect(plan4[:provider_name]).to eq 'SAMPLEでんき（旧名）'
      expect(plan4[:plan_name]).to eq '従量電灯B　たっぷりプラン'
      expect(plan4[:plan_name]).to be_present
    end

    context '使用量' do
      it '10A: 各プランの料金が存在する' do
        anpere = 10
        prices = described_class.each_prices(csv_data, anpere)
        expect(prices.size).to eq 4
        expect(prices[0][:price]).to eq 286.0
        expect(prices[1][:price]).to eq 0.0
        expect(prices[2][:price]).to eq 858.0
        expect(prices[3][:price]).to eq 858.0
      end

      it '30A: 各プランの料金が存在する' do
        anpere = 30
        consumption = 10
        prices = described_class.each_prices(csv_data, anpere, consumption)
        expect(prices.size).to eq 4
        expect(prices[0][:price]).to eq 858.0 + 19.88 * consumption
        expect(prices[1][:price]).to eq 0.0 + 26.4 * consumption
        expect(prices[2][:price]).to eq 858.0 + 23.67 * consumption
        expect(prices[3][:price]).to eq 858.0 + 19.88 * consumption
      end
    end
  end

  context 'plan_names' do
    it '各プラン名が存在する' do
      vals = described_class.send(:plan_names, csv_data)
      expect(vals.size).to eq 4
      expect(vals).to include('juryo-dento-x')
      expect(vals).to include('sample-plan')
      expect(vals).to include('test-denki-1')
      expect(vals).to include('sample-denki')
    end
  end

  context 'find_consumption_price' do
    let(:plan_name) { 'juryo-dento-x' }
    let(:rows) { csv_data.select { |r| r['plan_name'] == plan_name } }
    let(:price_up_to_120) { 19.88 }
    let(:price_up_to_300) { 26.48 }
    let(:price_over_300) { 30.57 }

    def expect_consumption_price(ampere, price_per_kwh)
      val = described_class.send(:find_consumption_price, rows, plan_name, ampere)
      expect(val).to eq price_per_kwh * ampere
    end

    it '使用量: 0' do
      val = described_class.send(:find_consumption_price, rows, plan_name, 0)
      expect(val).to eq 0.0
    end

    it '使用量: 1' do
      expect_consumption_price(1, price_up_to_120)
    end

    it '使用量: 120' do
      expect_consumption_price(120, price_up_to_120)
    end

    it '使用量: 121' do
      expect_consumption_price(121, price_up_to_300)
    end

    it '使用量: 250' do
      expect_consumption_price(250, price_up_to_300)
    end

    it '使用量: 300' do
      expect_consumption_price(300, price_up_to_300)
    end

    it '使用量: 301' do
      expect_consumption_price(301, price_over_300)
    end

    it '使用量: 500' do
      expect_consumption_price(500, price_over_300)
    end
  end
end
