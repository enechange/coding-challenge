# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/electricity_bill_simulations' do
  include_context 'with seed data'

  let(:valid_params) { { ampere: 30, kwh: 400 } }

  context 'with valid params' do
    it 'status 200 を返し、data 配列が provider_name / plan_name / price を持つ' do
      get '/api/v1/electricity_bill_simulations', params: valid_params

      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json['data']).to be_an(Array)
      expect(json['data']).to all(include('provider_name', 'plan_name', 'price'))
    end
  end

  context 'with invalid ampere' do
    it '不正な ampere で status 400 を返し、errors[0] が JSON:API 形式' do
      get '/api/v1/electricity_bill_simulations', params: { ampere: 25, kwh: 400 }

      expect(response).to have_http_status(:bad_request)
      json = response.parsed_body
      error = json['errors'].first
      expect(error['status']).to eq('400')
      expect(error['title']).to eq('Invalid Parameter')
      expect(error['detail']).to be_a(String)
      expect(error['source']['parameter']).to eq('ampere')
    end
  end

  context 'without params' do
    it 'パラメータなしで status 400 を返し、errors が 2 件' do
      get '/api/v1/electricity_bill_simulations'

      expect(response).to have_http_status(:bad_request)
      json = response.parsed_body
      expect(json['errors'].count).to eq(2)
    end
  end
end
