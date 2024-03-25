require 'rails_helper'

RSpec.describe "Api/v1/EnergyPrices", type: :request do
  describe "GET api/v1/energy_prices" do
    let(:search_params) { { compared_amperes: 30, consumption: 100 } }

    context 'response: 200' do
      before do
        get api_v1_energy_prices_path(search_params)
      end

      it 'response' do
        expect(response).to be_successful
        expect(response.status).to eq 200

        json = JSON.parse(response.body)
        expect(json).to be_present
        expect(json['energy_prices']).to be_present

        plan1 = json['energy_prices'][0]
        expect(plan1['provider_name']).to be_present
        expect(plan1['plan_name']).to be_present
        expect(plan1['price']).to be_present
      end
    end

    context 'params' do
      context 'compared_amperes' do
        it '契約アンペア数: nil' do
          params = { compared_amperes: nil, consumption: 100 }
          get api_v1_energy_prices_path(params)

          expect(response.status).to eq 422
          expect(JSON.parse(response.body)['error_message']).to eq '正しい契約アンペア数を入力してください。'
        end

        it '契約アンペア数: 9' do
          params = { compared_amperes: 9, consumption: 100 }
          get api_v1_energy_prices_path(params)

          expect(response.status).to eq 422
          expect(JSON.parse(response.body)['error_message']).to eq '正しい契約アンペア数を入力してください。'
        end

        it '契約アンペア数: 10' do
          params = { compared_amperes: 10, consumption: 100 }
          get api_v1_energy_prices_path(params)

          json = JSON.parse(response.body)
          plan1 = json['energy_prices'][0]
          expect(plan1['provider_name']).to be_present
          expect(plan1['plan_name']).to be_present
          expect(plan1['price']).to be_present
        end

        it '契約アンペア数: 15' do
          params = { compared_amperes: 15, consumption: 100 }
          get api_v1_energy_prices_path(params)

          json = JSON.parse(response.body)
          plan1 = json['energy_prices'][0]
          expect(plan1['provider_name']).to be_present
          expect(plan1['plan_name']).to be_present
          expect(plan1['price']).to be_present
        end

        it '契約アンペア数: 60' do
          params = { compared_amperes: 60, consumption: 100 }
          get api_v1_energy_prices_path(params)

          json = JSON.parse(response.body)
          plan1 = json['energy_prices'][0]
          expect(plan1['provider_name']).to be_present
          expect(plan1['plan_name']).to be_present
          expect(plan1['price']).to be_present
        end

        it '契約アンペア数: 61' do
          params = { compared_amperes: 61, consumption: 100 }
          get api_v1_energy_prices_path(params)

          expect(response.status).to eq 422
          expect(JSON.parse(response.body)['error_message']).to eq '正しい契約アンペア数を入力してください。'
        end
      end

      context 'consumption' do
        it '使用量下限値: 0' do
          params = { compared_amperes: 10, consumption: 0 }
          get api_v1_energy_prices_path(params)

          json = JSON.parse(response.body)
          plan1 = json['energy_prices'][0]
          expect(plan1['provider_name']).to be_present
          expect(plan1['plan_name']).to be_present
          expect(plan1['price']).to be_present
        end

        it '使用量: 150' do
          params = { compared_amperes: 10, consumption: 150 }
          get api_v1_energy_prices_path(params)

          json = JSON.parse(response.body)
          plan1 = json['energy_prices'][0]
          expect(plan1['provider_name']).to be_present
          expect(plan1['plan_name']).to be_present
          expect(plan1['price']).to be_present
        end

        it '使用量: 999999' do
          params = { compared_amperes: 10, consumption: 999999 }
          get api_v1_energy_prices_path(params)

          json = JSON.parse(response.body)
          plan1 = json['energy_prices'][0]
          expect(plan1['provider_name']).to be_present
          expect(plan1['plan_name']).to be_present
          expect(plan1['price']).to be_present
        end
      end
    end

    it 'csv_loadエラー' do
      expect(Utils::EnergyPrice).to receive(:load_csv).and_raise(StandardError)

      get api_v1_energy_prices_path(search_params)
      expect(response.status).to eq 422
      expect(JSON.parse(response.body)['error_message']).to eq 'データを取得できませんでした。'
    end
  end
end
