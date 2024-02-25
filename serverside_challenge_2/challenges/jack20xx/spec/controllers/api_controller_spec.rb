require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  describe 'validate_params method' do
    context 'when parameters are valid' do
      it 'should return information correctly' do
        allow_any_instance_of(ValidateParamsService).to receive(:validate_params).and_return([])
        allow_any_instance_of(CalculateChargesService).to receive(:calculate_charges).and_return(1500)
        get :show_charges, params: { amps: 10, watts: 100 }

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq(1500)
      end
    end

    context 'when parameters are invalid' do
      it 'should return information correctly' do
        allow_any_instance_of(ValidateParamsService).to receive(:validate_params).and_return(['Invalid params'])
        get :show_charges, params: { amps: 10, watts: 100 }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'errors' => ['Invalid params'] })
      end
    end
  end
end
