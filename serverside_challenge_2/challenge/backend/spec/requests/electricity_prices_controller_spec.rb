# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ElectricityPrices', type: :request do
  describe 'GET /electricity_prices' do
    let(:valid_params) { { ampere: 30, usage: 200 } }
    let(:invalid_ampere_params) { { ampere: 100, usage: 200 } }
    let(:negative_usage_params) { { ampere: 30, usage: -50 } }
    let(:string_ampere_params) { { ampere: 'abc', usage: 200 } }
    let(:string_usage_params) { { ampere: 30, usage: 'xyz' } }
    let(:missing_ampere_params) { { usage: 200 } }
    let(:missing_usage_params) { { ampere: 30 } }

    # 正常系
    describe '正常系' do
      context '正しいパラメータが指定された場合' do
        let(:expected_response) do
          [
            {
              'company_name' => '東京電力エナジーパートナー',
              'plan_name' => '従量電灯B',
              'price' => '2274.0'
            },
            {
              'company_name' => '東京電力エナジーパートナー',
              'plan_name' => 'スタンダードS',
              'price' => '3291.75'
            }
          ]
        end

        before do
          allow(ElectricityPriceCalculateService).to receive(:new)
            .and_return(double(calc: expected_response))
        end

        it '成功の応答を返し、レスポンスのボディにサービスで計算された結果が入っている' do
          get electricity_prices_url, params: valid_params
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to eq(expected_response)
        end
      end
    end

    # 異常系
    describe '異常系' do
      context '無効なアンペア数が指定された場合' do
        it 'それに対応するエラー応答を返す' do
          get electricity_prices_url, params: invalid_ampere_params
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to eq({
            'error' => "アンペア数(ampere)は #{ElectricityPricesController::ALLOWED_AMPERES.join('/')} のいずれかを指定してください"
          })
        end
      end

      context '使用量が負の数の場合' do
        it 'それに対応するエラー応答を返す' do
          get electricity_prices_url, params: negative_usage_params
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to eq({ 'error' => '使用量(usage)は 0 以上の整数を指定してください' })
        end
      end

      context 'アンペア数が文字列の場合' do
        it 'それに対応するエラー応答を返す' do
          get electricity_prices_url, params: string_ampere_params
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to eq({ 'error' => 'アンペア数(ampere)と使用量(usage)を整数で指定してください' })
        end
      end

      context '使用量が文字列の場合' do
        it 'それに対応するエラー応答を返す' do
          get electricity_prices_url, params: string_usage_params
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to eq({ 'error' => 'アンペア数(ampere)と使用量(usage)を整数で指定してください' })
        end
      end

      context 'アンペア数が指定されていない場合' do
        it 'それに対応するエラー応答を返す' do
          get electricity_prices_url, params: missing_ampere_params
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to eq({ 'error' => 'アンペア数(ampere)と使用量(usage)の両方が指定されていません' })
        end
      end

      context '使用量が指定されていない場合' do
        it 'それに対応するエラー応答を返す' do
          get electricity_prices_url, params: missing_usage_params
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to eq({ 'error' => 'アンペア数(ampere)と使用量(usage)の両方が指定されていません' })
        end
      end

      context 'サービス内でエラーが発生した場合' do
        before do
          allow(ElectricityPriceCalculateService).to receive(:new).and_raise(StandardError)
        end

        it '予期しないエラー応答を返す' do
          get electricity_prices_url, params: valid_params
          expect(response).to have_http_status(:internal_server_error)
          expect(JSON.parse(response.body)).to eq({ 'error' => '予期しないエラーが発生しました' })
        end
      end
    end
  end
end
