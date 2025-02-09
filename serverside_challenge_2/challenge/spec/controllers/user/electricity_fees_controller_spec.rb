# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::ElectricityFeesController do
  subject { get :index, params: params }

  describe 'GET #index' do
    let(:provider) { create(:electricity_provider, name: 'Test Provider') }
    let(:plan) { create(:electricity_plan, electricity_provider: provider, name: 'Test Plan') }
    let(:params) { { contract_ampere: contract_ampere, usage_kwh: usage_kwh } }

    before do
      create(:electricity_plan_basic_fee, electricity_plan: plan, ampere: 30, fee: 1000)
      create(:electricity_plan_basic_fee, electricity_plan: plan, ampere: 40, fee: 2000)
      create(:electricity_plan_usage_fee, electricity_plan: plan, min_usage: 0, fee: 10)
      create(:electricity_plan_usage_fee, electricity_plan: plan, min_usage: 150, fee: 15)
    end

    context 'when usage is 100 kWh' do
      let(:usage_kwh) { 100 }
      let(:contract_ampere) { 30 }

      it 'returns correct fee calculation' do
        subject
        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body
        expect(json_response.first).to include(
          'provider_name' => 'Test Provider',
          'plan_name' => 'Test Plan',
          'price' => '2000.0' # 1000 (basic fee) + 1000 (usage fee)
        )
      end
    end

    context 'when usage is 200 kWh' do
      let(:usage_kwh) { 200 }
      let(:contract_ampere) { 30 }

      it 'returns correct fee calculation' do
        subject
        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body
        expect(json_response.first).to include(
          'provider_name' => 'Test Provider',
          'plan_name' => 'Test Plan',
          'price' => '3250.0' # 1000 (basic fee) + 1500 (usage fee1) + 750 (usage fee2)
        )
      end
    end

    context 'when contract_ampere is different' do
      let(:usage_kwh) { 100 }
      let(:contract_ampere) { 40 }

      it 'returns correct fee calculation' do
        subject
        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body
        expect(json_response.first).to include(
          'provider_name' => 'Test Provider',
          'plan_name' => 'Test Plan',
          'price' => '3000.0' # 2000 (basic fee) + 1000 (usage fee)
        )
      end
    end

    context 'when input is invalid' do
      let(:params) { { contract_ampere: 0, usage_kwh: -1 } }

      it 'returns error' do
        subject
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when params are missing' do
      let(:params) { { contract_ampere: nil, usage_kwh: nil } }

      it 'returns error' do
        subject
        expect(response).to have_http_status(:bad_request)
        json_response = response.parsed_body
        expect(json_response['error']).to eq('Both contract_ampere and usage_kwh are required')
      end
    end

    context 'when contract_ampere is invalid' do
      let(:usage_kwh) { 100 }
      let(:contract_ampere) { 25 }

      it 'returns error' do
        subject
        expect(response).to have_http_status(:bad_request)
        json_response = response.parsed_body
        expect(json_response['error']).to eq('Invalid contract_ampere value')
      end
    end
  end
end
