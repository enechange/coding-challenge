require 'rails_helper'

RSpec.describe CalculateChargesService do
  describe 'calculate_charges method' do
    before do
      @original_files = CalculateChargesService.class_variable_get(:@@electricity_files)
      CalculateChargesService.class_variable_set(:@@electricity_files, [TEST_CHARGES_PATH])
    end

    after do
      CalculateChargesService.class_variable_set(:@@electricity_files, @original_files)
    end

    let(:service) { CalculateChargesService.new(amps, watts) }
    subject { service.calculate_charges }
    context 'when parameters are correct' do
      let(:amps) { 50 }
      let(:watts) { 525 }
      it 'should return correct properties' do
        expect(subject.first).to include(:provider_name, :plan_name, :price)
      end

      it 'should calculate charges correctly' do
        expect(subject.first[:price]).to be_a(Numeric)
        expect(subject.first[:price]).to eq(10712)
      end
    end

    context 'when amps are unmatched with data' do
      let(:amps) { 0 }
      let(:watts) { 500 }
      it 'should return no_data' do
        expect(subject.first[:price]).to be_a(String)
        expect(subject.first[:price]).to eq('no_data')
      end
    end
  end
end
