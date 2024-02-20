require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  describe 'Logic tests' do
    context 'validate_params method' do
      it 'should return information with valid data' do
        allow_any_instance_of(ValidateParamsService).to receive(:validate_params).and_return([])
        allow_any_instance_of(CalculateChargesService).to receive(:calculate_charges).and_return(1500)
        get :show_charges, params: { amps: 10, watts: 100 }

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq(1500)
      end

      it 'should return information with invalid data' do
        allow_any_instance_of(ValidateParamsService).to receive(:validate_params).and_return(['Invalid params'])
        get :show_charges, params: { amps: 10, watts: 100 }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'errors' => ['Invalid params'] })
      end
    end

    context 'ParameterMissing' do
      it 'should return information with invalid parameters' do
        get :show_charges, params: { amps: 10 }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("'watts'が正しくありません")

        get :show_charges, params: { watts: 100 }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("'amps'が正しくありません")
      end
    end
  end
end
