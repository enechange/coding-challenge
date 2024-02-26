require 'rails_helper'

RSpec.describe ValidateParamsService do
  describe 'validate_params method' do
    let(:service) { ValidateParamsService.new(params) }

    context 'when amps parameter is missing' do
      let(:params) { ActionController::Parameters.new(watts: '200') }

      it 'should return error messages correctly' do
        result = service.validate_params
        expect(result['invalid_parameter']).to eq("'ampsが正しくありません'")
      end
    end

    context 'when watts parameter is missing' do
      let(:params) { ActionController::Parameters.new(amps: '100') }

      it 'should return error messages correctly' do
        result = service.validate_params
        expect(result['invalid_parameter']).to eq("'wattsが正しくありません'")
      end
    end

    context 'when parameters are valid' do
      let(:params) { ActionController::Parameters.new({ amps: '10', watts: '50' }) }

      it 'should return empty' do
        expect(service.validate_params).to eq({})
      end
    end

    context 'when parameter numbers are invalid' do
      let(:params) { ActionController::Parameters.new({ amps: '10A', watts: '50' }) }

      it 'should handle invalid_number error correctly' do
        expect(service.validate_params).to include('invalid_number')
      end
    end

    context 'when amp numbers are unmatched with data' do
      let(:params) { ActionController::Parameters.new({ amps: '0', watts: '50' }) }

      it 'should handle unmatched_amp error correctly' do
        expect(service.validate_params).to include('unmatched_amp')
      end
    end
  end
end
