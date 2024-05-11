require 'rails_helper'

describe 'Api::ElectricityRateSimulations', type: :request do
  describe 'GET /api/electricity_rate_simulations' do
    let(:params) { { amperage: 10, usage_kwh: 100} }

    subject do
      get api_electricity_rate_simulations_path, params:
      response.body
    end
  end

  it 'returns http success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'returns the correct response' do
    subject
    expect(JSON.parse(response.body)).to eq(
      [
        {
          provider_name: 'Provider A',
          plan_name: 'Plan A',
          price: 1000
        }
      ]
    )
  end
end
