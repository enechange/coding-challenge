require 'rails_helper'

describe 'Api::ElectricityRateSimulations', type: :request do
  describe 'GET /api/electricity_rate_simulations' do
    let(:params) { { amperage: 10, usage_kwh: 100} }

    subject do
      get api_electricity_rate_simulations_path, params:
    end

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct response' do
      subject
      expect(JSON.parse(response.body)).to include(
        { 'provider_name' => 'Provider A', 'plan_name' => 'Plan A', 'price' => 1000 }
      )
    end

    context 'when the params are invalid' do
      let(:params) { { dummy: 10 } }

      it 'returns http bad request' do
        subject
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
