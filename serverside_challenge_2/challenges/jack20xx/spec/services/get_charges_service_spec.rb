require 'rails_helper'

RSpec.describe GetChargesService, type: :model do
  before do
    @charges_file = Rails.root.join('spec', 'test_data', 'charges.yml')
  end

  describe 'Methods related to provider information' do
    context 'when a yml file is read' do
      it 'should return a provider information correctly' do
        charge = GetChargesService.new(50, 50, @charges_file)
        expect(charge.provider_name).to eq 'Test Provider'
        expect(charge.plan_name).to eq 'Test Plan'
      end
    end
  end

  describe 'Methods related to calculation' do
    context 'when a yml file is read' do
      it 'should calculate charges' do
        charge = GetChargesService.new(50, 50, @charges_file)
        expect(charge.calculate).to eq 1500

        charge = GetChargesService.new(60, 50, @charges_file)
        expect(charge.calculate).to eq 2500
      end

      it 'should calculate charges and change conditions correctly' do
        charge = GetChargesService.new(50, 500, @charges_file)
        expect(charge.calculate).to eq 22000

        charge = GetChargesService.new(60, 500, @charges_file)
        expect(charge.calculate).to eq 23000
      end

      it 'should show "no_data" when amp_numbers is not matched with data' do
        charge = GetChargesService.new(10, 50, @charges_file)
        expect(charge.calculate).to eq 'no_data'
      end
    end
  end
end
