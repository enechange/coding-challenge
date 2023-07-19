require 'rails_helper'

RSpec.describe "Providers", type: :request do
  describe "GET /electricity_rate_simulation" do
    context '正しく値が入力されている場合' do
      it 'リクエストが成功し、会社名・プラン名・金額が返されること' do
        tepco = {
          'provider_name' => '東京電力エナジーパートナー',
          'plan_name' => '従量電灯B',
          'price' => 4565
        }
        looop = {
          'provider_name' => 'Looopでんき',
          'plan_name' => 'おうちプラン',
          'price' => 3696
        }
        tokyo_gas = {
          'provider_name' => '東京ガス',
          'plan_name' => 'ずっとも電気1',
          'price' => 4171
        }
        jxtg = {
          'provider_name' => 'JXTGでんき',
          'plan_name' => '従量電灯Bたっぷりプラン',
          'price' => 4565
        }
        params = {
          ampere: 30,
          electricity_usage: 140
        }

        get electricity_rate_simulation_path params
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)).to include(tepco, looop, tokyo_gas, jxtg)
      end
    end

    context 'アンペアか電力使用量どちらかが空の場合' do
      it 'bad_requestがメッセージとともに返されること' do
        ampere = 30
        electricity_usage = 140

        get electricity_rate_simulation_path ampere
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['title']).to eq('必要な値がありません')
        get electricity_rate_simulation_path electricity_usage
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['title']).to eq('必要な値がありません')
      end
    end

    context 'アンペアが10 / 15 / 20 / 30 / 40 / 50 / 60 のいずれかでない場合' do
      it 'bad_requestがメッセージとともに返されること' do
        params = {
          ampere: 5,
          electricity_usage: 140
        }

        get electricity_rate_simulation_path params
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['title']).to eq('契約アンペア数は10 / 15 / 20 / 30 / 40 / 50 / 60 のいずれかから選択してください')
      end
    end

    context '電力使用量が0以上の整数ではない場合' do
      it 'bad_requestがメッセージとともに返されること' do
        params = {
          ampere: 30,
          electricity_usage: -140
        }

        get electricity_rate_simulation_path params
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['title']).to eq('電力使用量は0以上の整数でご入力ください')
      end
    end
  end
end
