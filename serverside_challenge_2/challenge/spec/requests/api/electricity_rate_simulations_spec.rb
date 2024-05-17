# frozen_string_literal: true

require 'rails_helper'

describe 'Api::ElectricityRateSimulations', type: :request do
  let(:provider) { create(:provider) }
  let!(:electricity_plan) { create(:electricity_plan, provider:) }
  let!(:basic_rate) { create(:basic_rate, electricity_plan:, amperage: 10, rate: 10.10) }

  before do
    create(:usage_rate, electricity_plan:, limit_kwh: 120, rate: 20.10)
    create(:usage_rate, electricity_plan:, limit_kwh: 300, rate: 30.20)
    create(:usage_rate, electricity_plan:, limit_kwh: nil, rate: 40.30)
  end

  describe 'GET /api/electricity_rate_simulations' do
    let(:params) { { amperage: 10, usage_kwh: 100 } }

    subject do
      get api_electricity_rate_simulations_path, params:
    end

    it 'HTTPステータスコード200を返すこと' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'JSONレスポンスを返すこと' do
      subject
      expect(response.parsed_body).to include(
        { 'provider_name' => provider.name, 'plan_name' => electricity_plan.name, 'total_amount' => 2020, 'error_message' => nil }
      )
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

    context '指定したアンペア数が基本料金に存在しないとき' do
      let(:params) { { amperage: 30, usage_kwh: 100 } }

      it 'total_priceがnilでerror_messageが「アンペア数に対応する基本料金が見つからないため料金を計算できません」であること' do
        subject
        expect(response.parsed_body).to include(
          { 'provider_name' => provider.name, 'plan_name' => electricity_plan.name, 'total_amount' => nil, 'error_message' => 'アンペア数に対応する基本料金が見つからないため料金を計算できません' }
        )
      end
    end
  end
end
