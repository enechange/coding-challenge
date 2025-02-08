# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ElectricityProvidersController do
  subject { get :index }

  let(:provider) { create(:electricity_provider, name: 'Test Provider') }
  let(:plan) { create(:electricity_plan, electricity_provider: provider, name: 'Test Plan') }

  before do
    create(:electricity_plan_basic_fee, electricity_plan: plan, ampere: 30, fee: 1000)
    create(:electricity_plan_usage_fee, electricity_plan: plan, min_usage: 0, fee: 20)
  end

  describe 'GET #index' do
    it 'returns a list of electricity plans with fees' do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq(
        [
          'id' => provider.id,
          'name' => 'Test Provider',
          'electricity_plans' => [
            {
              'id' => plan.id,
              'name' => 'Test Plan',
              'electricity_plan_basic_fees' => [
                {
                  'ampere' => 30,
                  'fee' => '1000.0'
                }
              ],
              'electricity_plan_usage_fees' => [
                {
                  'min_usage' => 0,
                  'fee' => '20.0'
                }
              ]
            }
          ]
        ]
      )
    end
  end
end
