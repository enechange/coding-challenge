require 'rails_helper'

RSpec.describe ValidateParamsService do
  describe 'validate_params method' do
    let(:service) { ValidateParamsService.new(params) }
    subject { service.validate_params }
    context 'when amps parameter is missing' do
      let(:params) { ActionController::Parameters.new(watts: '200') }

      it 'should return error messages correctly' do
        expect(subject['invalid_parameter']).to eq("'ampsが正しくありません'")
      end
    end

    context 'when watts parameter is missing' do
      let(:params) { ActionController::Parameters.new(amps: '100') }

      it 'should return error messages correctly' do
        expect(subject['invalid_parameter']).to eq("'wattsが正しくありません'")
      end
    end

    context 'when parameters are valid' do
      let(:params) { ActionController::Parameters.new({ amps: '10', watts: '50' }) }

      it 'should return empty' do
        expect(subject).to eq({})
      end
    end

    context 'when parameter numbers are invalid' do
      let(:params) { ActionController::Parameters.new({ amps: '10A', watts: '50' }) }

      it 'should handle invalid_number error correctly' do
        expect(subject).to have_key('invalid_number')
      end
    end

    context 'when amp numbers are unmatched with data' do
      let(:params) { ActionController::Parameters.new({ amps: '0', watts: '50' }) }

      it 'should handle unmatched_amp error correctly' do
        expect(subject).to have_key('unmatched_amp')
      end
    end
  end
end
