require 'rails_helper'

RSpec.describe ValidateParamsService do
  describe 'validate_params method' do
    context 'when parameters are valid' do
      it 'should return empty' do
        @validation_service = ValidateParamsService.new('10', '50')
        expect(@validation_service.validate_params).to eq({})

        @validation_service = ValidateParamsService.new('10', '0')
        expect(@validation_service.validate_params).to eq({})
      end
    end

    context 'when parameters are invalid' do
      it 'should handle invalid_number error correctly' do
        @validation_service = ValidateParamsService.new('10A', '50')
        expect(@validation_service.validate_params).to include('invalid_number')

        @validation_service = ValidateParamsService.new('10', '50W')
        expect(@validation_service.validate_params).to include('invalid_number')
      end

      it 'should handle invalid_amp error correctly' do
        @validation_service = ValidateParamsService.new('0', '50')
        expect(@validation_service.validate_params).to include('invalid_amp')
      end
    end
  end
end