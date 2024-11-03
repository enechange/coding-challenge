require 'rails_helper'

RSpec.describe 'API /api/electricity/calculate', type: :request do
  let(:provider1) { create(:provider, name: 'provider1') }
  let(:provider2) { create(:provider, name: 'provider2') }
  # plan1
  let(:plan1_provider1) { create(:plan, name: 'plan1', provider: provider1) }
  let(:plan1_amp_10) { create(:basic_price, plan: plan1_provider1, amperage: 10, price: 100.01) }
  let(:plan1_rate_0) { create(:measured_rate, plan: plan1_provider1, electricity_usage_min: 0, electricity_usage_max: nil, price: 10.01) }
  # plan2
  let(:plan2_provider2) { create(:plan, name: 'plan2', provider: provider2) }
  let(:plan2_amp_10) { create(:basic_price, plan: plan2_provider2, amperage: 10, price: 200.01) }
  let(:plan2_rate_0) { create(:measured_rate, plan: plan2_provider2, electricity_usage_min: 0, electricity_usage_max: nil, price: 20.03) }

  describe 'create' do
    let(:params) do
      {
        amperage: 10,
        electricity_usage_kwh: 1
      }
    end
    let(:headers) { { "Content-Type" => "application/json" } }

    before do
      plan1_amp_10
      plan1_rate_0
      plan2_amp_10
      plan2_rate_0
    end

    context '正常' do
      it 'レスポンスが正常に帰ること' do
        post '/api/electricity/calculate', headers: headers, params: params.to_json

        expect(response).to have_http_status(200)
        body = JSON.parse(response.body, symbolize_names: true)

        expect(body[:errors]).to be_nil
        expect(body[:data].size).to eq 2
        data = body[:data]
        expect(data[0][:provider][:id]).to eq provider1.id
        expect(data[0][:provider][:name]).to eq provider1.name
        expect(data[0][:plan][:id]).to eq plan1_provider1.id
        expect(data[0][:plan][:name]).to eq plan1_provider1.name
        expect(data[0][:plan][:price]).to eq 110

        expect(data[1][:provider][:id]).to eq provider2.id
        expect(data[1][:provider][:name]).to eq provider2.name
        expect(data[1][:plan][:id]).to eq plan2_provider2.id
        expect(data[1][:plan][:name]).to eq plan2_provider2.name
        expect(data[1][:plan][:price]).to eq 220
      end

      it 'Seedデータを使用して計算可能であること' do
        Rails.application.load_seed
        post '/api/electricity/calculate', headers: headers, params: params.to_json

        expect(response).to have_http_status(200)
        body = JSON.parse(response.body, symbolize_names: true)

        expect(body[:errors]).to be_nil
        expect(body[:data]).to be_present
      end
    end

    context 'リクエストパラメータ不正' do
      context 'amperage' do
        it '指定されていない場合、エラーとなる' do
          params.delete(:amperage)
          post '/api/electricity/calculate', headers: headers, params: params.to_json

          expect(response).to have_http_status(400)
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:message]).to include('リクエストパラメーターが正しくありません。')

          expect(body[:details].size).to eq 1
          expect(body[:details][0][:field]).to eq 'amperage'
          expect(body[:details][0][:message]).to include('のいずれかを指定してください。')
        end

        it '文字列の場合、エラーとなる' do
          params[:amperage] = '10'
          post '/api/electricity/calculate', headers: headers, params: params.to_json

          expect(response).to have_http_status(400)
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:message]).to include('リクエストパラメーターが正しくありません。')

          expect(body[:details].size).to eq 1
          expect(body[:details][0][:field]).to eq 'amperage'
          expect(body[:details][0][:message]).to include('のいずれかを指定してください。')
        end
      end

      context 'electricity_usage_kwh' do
        it '指定されていない場合、エラーとなる' do
          params.delete(:electricity_usage_kwh)
          post '/api/electricity/calculate', headers: headers, params: params.to_json

          expect(response).to have_http_status(400)
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:message]).to include('リクエストパラメーターが正しくありません。')

          expect(body[:details].size).to eq 1
          expect(body[:details][0][:field]).to eq 'electricity_usage_kwh'
          expect(body[:details][0][:message]).to eq '整数を指定してください。'
        end

        it '文字列の場合、エラーとなる' do
          params[:electricity_usage_kwh] = '20'
          post '/api/electricity/calculate', headers: headers, params: params.to_json

          expect(response).to have_http_status(400)
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:message]).to include('リクエストパラメーターが正しくありません。')

          expect(body[:details].size).to eq 1
          expect(body[:details][0][:field]).to eq 'electricity_usage_kwh'
          expect(body[:details][0][:message]).to eq '整数を指定してください。'
        end

        it '実数の場合、エラーとなる' do
          params[:electricity_usage_kwh] = 20.0
          post '/api/electricity/calculate', headers: headers, params: params.to_json

          expect(response).to have_http_status(400)
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:message]).to include('リクエストパラメーターが正しくありません。')

          expect(body[:details].size).to eq 1
          expect(body[:details][0][:field]).to eq 'electricity_usage_kwh'
          expect(body[:details][0][:message]).to eq '整数を指定してください。'
        end
      end
    end
  end
end
