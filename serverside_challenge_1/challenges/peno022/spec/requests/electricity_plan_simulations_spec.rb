# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ElectricityPlanSimulations', type: :request do
  let(:plans) { BuildElectricityPlansService.new.call(::PLANS) }

  describe 'GET /api/electricity_plan_simulations' do
    context 'リクエストのパラメータが適切なとき' do
      it '200 OKでプランごとの料金情報を返す' do
        get api_electricity_plan_simulations_path, params: { consumption: 300, contract_amperage: 30 }
        simulator = ElectricityPlansSimulator.new(plans:, consumption: 300, contract_amperage: 30)
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq simulator.calculate_results.to_json
      end
    end

    context 'contract_amperageがnilのとき' do
      it '400 Bad Requestでエラーを返す' do
        get api_electricity_plan_simulations_path, params: { consumption: 300, contract_amperage: nil }
        simulator = ElectricityPlansSimulator.new(plans:, consumption: 300, contract_amperage: nil)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({ errors: simulator.validate_params }.to_json)
      end
    end

    context 'contract_amperageが不正な値のとき' do
      it '400 Bad Requestでエラーを返す' do
        get api_electricity_plan_simulations_path, params: { consumption: 300, contract_amperage: 0 }
        simulator = ElectricityPlansSimulator.new(plans:, consumption: 300, contract_amperage: 0)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({ errors: simulator.validate_params }.to_json)
      end
    end

    context 'consumptionがnilのとき' do
      it '400 Bad Requestでエラーを返す' do
        get api_electricity_plan_simulations_path, params: { consumption: nil, contract_amperage: 10 }
        simulator = ElectricityPlansSimulator.new(plans:, consumption: nil, contract_amperage: 10)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({ errors: simulator.validate_params }.to_json)
      end
    end

    context 'consumptionが不正な値のとき' do
      it '400 Bad Requestでエラーを返す' do
        get api_electricity_plan_simulations_path, params: { consumption: 0.1, contract_amperage: 10 }
        simulator = ElectricityPlansSimulator.new(plans:, consumption: 0.1, contract_amperage: 10)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({ errors: simulator.validate_params }.to_json)
      end
    end

    context 'consumptionとcontract_amperageがnilのとき' do
      it '400 Bad Requestでエラーを返す' do
        get api_electricity_plan_simulations_path, params: { consumption: nil, contract_amperage: nil }
        simulator = ElectricityPlansSimulator.new(plans:, consumption: nil, contract_amperage: nil)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({ errors: simulator.validate_params }.to_json)
      end
    end

    context 'consumptionがnil、contract_amperageが不正な値のとき' do
      it '400 Bad Requestでエラーを返す' do
        get api_electricity_plan_simulations_path, params: { consumption: nil, contract_amperage: 0 }
        simulator = ElectricityPlansSimulator.new(plans:, consumption: nil, contract_amperage: 0)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({ errors: simulator.validate_params }.to_json)
      end
    end

    context 'consumptionが不正な値、contract_amperageがnilのとき' do
      it '400 Bad Requestでエラーを返す' do
        get api_electricity_plan_simulations_path, params: { consumption: 0.1, contract_amperage: nil }
        simulator = ElectricityPlansSimulator.new(plans:, consumption: 0.1, contract_amperage: nil)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({ errors: simulator.validate_params }.to_json)
      end
    end

    context 'consumptionとcontract_amperageが不正な値のとき' do
      it '400 Bad Requestでエラーを返す' do
        get api_electricity_plan_simulations_path, params: { consumption: 0.1, contract_amperage: 0 }
        simulator = ElectricityPlansSimulator.new(plans:, consumption: 0.1, contract_amperage: 0)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({ errors: simulator.validate_params }.to_json)
      end
    end

    context 'consumption、contract_amperage以外のパラメータが含まれているとき' do
      it '他のパラメータは無視されて、200 OKでプランごとの料金情報を返す' do
        get api_electricity_plan_simulations_path, params: { consumption: 300, contract_amperage: 30, other: 'other' }
        simulator = ElectricityPlansSimulator.new(plans:, consumption: 300, contract_amperage: 30)
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq simulator.calculate_results.to_json
      end
    end
  end
end
