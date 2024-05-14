# frozen_string_literal: true

require 'rails_helper'

describe 'Api::ElectricityRateSimulations', type: :request do
  describe 'GET /api/electricity_rate_simulations' do
    let(:params) { { amperage: 30, usage_kwh: 100 } }

    subject do
      get api_electricity_rate_simulations_path, params:
    end

    it 'HTTPステータスコード200を返すこと' do
      subject
      expect(response).to have_http_status(:success)
    end

    context '無効なパラメータを指定したとき' do
      let(:params) { { dummy: 10 } }

      it 'HTTPステータスコード400を返すこと' do
        subject
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'バリデーションエラーとなる値を指定したとき' do
      let(:params) { { amperage: 999, usage_kwh: 100 } }

      it 'HTTPステータスコード422を返すこと' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context '電力会社の料金プランのシュミレーションが成功したとき' do
      it '[東京電力エナジーパートナー] 従量電灯Bの料金プランが含まれていること' do
        subject
        expect(response.parsed_body).to include(
          { 'provider_name' => '東京電力エナジーパートナー', 'plan_name' => '従量電灯B', 'price' => 2846, 'error_message' => nil }
        )
      end

      it '[東京電力エナジーパートナー] スタンダードSの料金プランが含まれていること' do
        subject
        expect(response.parsed_body).to include(
          { 'provider_name' => '東京電力エナジーパートナー', 'plan_name' => 'スタンダードS', 'price' => 3915, 'error_message' => nil }
        )
      end

      it '[東京ガス] スタンダードSの料金プランが含まれていること' do
        subject
        expect(response.parsed_body).to include(
          { 'provider_name' => '東京ガス', 'plan_name' => 'ずっとも電気1', 'price' => 3225, 'error_message' => nil }
        )
      end

      it '[Looopでんき] スタンダードSの料金プランが含まれていること' do
        subject
        expect(response.parsed_body).to include(
          { 'provider_name' => 'Looopでんき', 'plan_name' => 'おうちプラン', 'price' => 2880, 'error_message' => nil }
        )
      end
    end

    context '指定したアンペア数が基本料金に存在しないとき' do
      let(:params) { { amperage: 10, usage_kwh: 100 } }

      it 'priceがnilでerror_messageが「アンペア数に対応する基本料金が見つからないため料金を計算できません」であること' do
        subject
        expect(response.parsed_body).to include(
          { 'provider_name' => '東京ガス', 'plan_name' => 'ずっとも電気1', 'price' => nil, 'error_message' => 'アンペア数に対応する基本料金が見つからないため料金を計算できません' }
        )
      end
    end
  end
end
