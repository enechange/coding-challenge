# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ElectricityPlansController do
  subject { post :upload_csv, params: { basic_fee_file: basic_fee_file, usage_fee_file: usage_fee_file } }

  describe 'POST #upload_csv' do
    let(:basic_fee_file_path) { Rails.root.join('test/fixtures/files/electricity_plans.csv') }
    let(:usage_fee_file_path) { Rails.root.join('test/fixtures/files/electricity_plan_usage_fees.csv') }
    let(:invalid_basic_fee_file_path) { Rails.root.join('test/fixtures/files/invalid_electricity_plans.csv') }
    let(:basic_fee_file) { fixture_file_upload(basic_fee_file_path, 'text/csv') }
    let(:usage_fee_file) { fixture_file_upload(usage_fee_file_path, 'text/csv') }
    let(:invalid_basic_fee_file) { fixture_file_upload(invalid_basic_fee_file_path, 'text/csv') }

    it 'uploads the CSV files and updates the database' do
      subject

      expect(response).to have_http_status(:ok)

      provider = ElectricityProvider.find_by!(name: '東京電力エナジーパートナー')
      expect(provider).not_to be_nil

      plan = provider.electricity_plans.find_by!(name: '従量電灯B')
      expect(plan).not_to be_nil

      basic_fee = plan.electricity_plan_basic_fees.find_by!(ampere: 10)
      expect(basic_fee.fee).to eq(286.00)

      usage_fee = plan.electricity_plan_usage_fees.find_by!(min_usage: 0)
      expect(usage_fee.fee).to eq(19.88)
    end

    it 'returns error for invalid ampere values in CSV' do
      post :upload_csv, params: { basic_fee_file: invalid_basic_fee_file, usage_fee_file: usage_fee_file }

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = response.parsed_body
      expect(json_response['error']).to include('Ampere 5 is not a valid ampere')
    end
  end
end
