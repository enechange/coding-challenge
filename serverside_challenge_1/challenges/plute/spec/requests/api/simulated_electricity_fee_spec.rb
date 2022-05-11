require 'rails_helper'

RSpec.describe "Api::SimulatedElectricityFee", type: :request do
  describe '/api/simulated_electricity_fee' do
    let!(:provider) { create(:provider, name: 'provider_hoge') }
    let!(:plan) { create(:plan, provider: provider, name: 'plan_hoge') }
    before do
      create(:base_fee, plan: plan, ampere: 10, base_fee: 286.0)
      create(:base_fee, plan: plan, ampere: 15, base_fee: 429.0)
      create(:base_fee, plan: plan, ampere: 20, base_fee: 572.0)
  
      create(:usage_fee, plan: plan, min_usage: 0, max_usage: 120, unit_usage_fee: 19.88)
      create(:usage_fee, plan: plan, min_usage: 120, max_usage: 300, unit_usage_fee: 26.48)
      create(:usage_fee, plan: plan, min_usage: 300, max_usage: 99999, unit_usage_fee: 30.57)
    end

    context 'when params are valid' do
      it 'returns calclated price' do
        get '/api/simulated_electricity_fee?ampere=20&usage=400'

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body, symbolize_names: true)).to eq([{
          provider_name: 'provider_hoge',
          plan_name: 'plan_hoge',
          price: 10781.0 # 572.0 + 19.88*120 + 26.48*180 + 30.57*100
        }])
      end
    end

    context 'when ampere param is empty' do
      it 'retuens 400' do
        get '/api/simulated_electricity_fee?usage=400'

        expect(response.status).to eq(400)
        expect(JSON.parse(response.body, symbolize_names: true)).to eq({
          code: 'E0001',
          title: 'アンペアが指定されていません'
        })
      end
    end

    context 'when ampere is not integer' do
      it 'retuens 400' do
        get '/api/simulated_electricity_fee?ampere=10.1&usage=400'

        expect(response.status).to eq(400)
        expect(JSON.parse(response.body, symbolize_names: true)).to eq({
          code: 'E0002',
          title: '指定された値が整数ではありません。アンペアは10, 15, 20, 30, 40, 50, 60のいずれかの整数で指定してください'
        })
      end
    end

    context 'when ampere is unacceptable value' do
      it 'retuens 400' do
        get '/api/simulated_electricity_fee?ampere=99&usage=400'

        expect(response.status).to eq(400)
        expect(JSON.parse(response.body, symbolize_names: true)).to eq({
          code: 'E0003',
          title: 'アンペアは10, 15, 20, 30, 40, 50, 60のいずれかの整数で指定してください'
        })
      end
    end

    context 'when usage param is empty' do
      it 'retuens 400' do
        get '/api/simulated_electricity_fee?ampere=20'

        expect(response.status).to eq(400)
        expect(JSON.parse(response.body, symbolize_names: true)).to eq({
          code: 'E0101',
          title: '使用量が指定されていません'
        })
      end
    end

    context 'when usage is not integer' do
      it 'retuens 400' do
        get '/api/simulated_electricity_fee?ampere=20&usage=100.1'

        expect(response.status).to eq(400)
        expect(JSON.parse(response.body, symbolize_names: true)).to eq({
          code: 'E0102',
          title: '指定された値が整数ではありません。使用量は0以上99,999以下の整数で指定してください'
        })
      end
    end

    context 'when usage is larger than 99,999' do
      it 'retuens 400' do
        get '/api/simulated_electricity_fee?ampere=20&usage=100000'

        expect(response.status).to eq(400)
        expect(JSON.parse(response.body, symbolize_names: true)).to eq({
          code: 'E0103',
          title: '使用量は0以上99,999以下の整数で指定してください'
        })
      end
    end    
  end
end