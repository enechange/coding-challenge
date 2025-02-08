# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::ElectricityFeesController do
  describe 'GET #index' do
    let(:provider) { create(:electricity_provider, name: 'Test Provider') }
    let(:plan) { create(:electricity_plan, electricity_provider: provider, name: 'Test Plan') }
    let!(:basic_fee) { create(:electricity_plan_basic_fee, electricity_plan: plan, ampere: 30, fee: 1000) }
    let!(:usage_fee1) { create(:electricity_plan_usage_fee, electricity_plan: plan, min_usage: 0, fee: 10) }
    let!(:usage_fee2) { create(:electricity_plan_usage_fee, electricity_plan: plan, min_usage: 150, fee: 15) }

    it 'returns correct fee calculation for 100 kWh' do
      get :index, params: { contract_ampere: 30, usage_kwh: 100 }
      expect(response).to have_http_status(:ok)
      json_response = response.parsed_body
      expect(json_response.first).to include(
        'provider_name' => 'Test Provider',
        'plan_name' => 'Test Plan',
        'price' => '2000.0' # 1000 (basic fee) + 1000 (usage fee)
      )
    end

    it 'returns correct fee calculation for 200 kWh' do
      get :index, params: { contract_ampere: 30, usage_kwh: 200 }
      expect(response).to have_http_status(:ok)
      json_response = response.parsed_body
      expect(json_response.first).to include(
        'provider_name' => 'Test Provider',
        'plan_name' => 'Test Plan',
        'price' => '3250.0' # 1000 (basic fee) + 1500 (usage fee1) + 750 (usage fee2)
      )
    end

    it 'returns error for invalid input' do
      get :index, params: { contract_ampere: 0, usage_kwh: -1 }
      expect(response).to have_http_status(:bad_request)
    end
  end
end
