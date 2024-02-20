require 'rails_helper'

RSpec.describe CalculateChargesService do
  describe 'Logic tests' do
    context 'calculate_charges method' do
      it 'should return charges data with correct properties' do
        @service = CalculateChargesService.new(50, 500)
        charges = @service.calculate_charges
        expect(charges.first).to include(:provider_name, :plan_name, :price)
      end

      it 'should calculate prices correctly' do
        @service = CalculateChargesService.new(50, 500)
        charges = @service.calculate_charges
        expect(charges.first[:price]).to be_a(Numeric)

        @service = CalculateChargesService.new(0, 500)
        charges = @service.calculate_charges
        expect(charges.first[:price]).to be_a(String)
        expect(charges.first[:price]).to eq('no_data')
      end
    end
  end
end
