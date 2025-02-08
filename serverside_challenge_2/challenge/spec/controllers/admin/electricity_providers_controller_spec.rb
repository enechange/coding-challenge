# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ElectricityProvidersController do
  describe 'GET #index' do
    it 'returns a list of electricity plans with fees' do
      provider = ElectricityProvider.create!(name: 'Test Provider')
      plan = provider.electricity_plans.create!(name: 'Test Plan')
      plan.electricity_plan_basic_fees.create!(ampere: 30, fee: 1000)
      plan.electricity_plan_usage_fees.create!(min_usage: 0, fee: 20)

      get :index
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
