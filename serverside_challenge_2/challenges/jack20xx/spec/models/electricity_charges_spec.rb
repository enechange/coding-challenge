require 'rails_helper'

RSpec.describe ElectricityCharges, type: :model do
  before do
    @charges_file = Rails.root.join('spec', 'test_data', 'charges.yml')
  end

  describe 'Methods related to provider information' do
    context 'when a yml file is read' do
      it 'should return a provider information correctly' do
        @bill = ElectricityCharges.new(50, 50, @charges_file)
        expect(@bill.provider_name).to eq 'Test Provider'
        expect(@bill.plan_name).to eq 'Test Plan'
      end
    end
  end

  describe 'Methods related to calculation' do
    context 'when a yml file is read' do
      it 'should calculate charges' do
        @bill = ElectricityCharges.new(50, 50, @charges_file)
        expect(@bill.calculate).to eq 1500

        @bill = ElectricityCharges.new(60, 50, @charges_file)
        expect(@bill.calculate).to eq 2500
      end

      it 'should calculate charges and change conditions correctly' do
        @bill = ElectricityCharges.new(50, 500, @charges_file)
        expect(@bill.calculate).to eq 26000

        @bill = ElectricityCharges.new(60, 500, @charges_file)
        expect(@bill.calculate).to eq 27000
      end

      it 'should show "no_data" when amp_numbers is not matched with data' do
        @bill = ElectricityCharges.new(10, 50, @charges_file)
        expect(@bill.calculate).to eq 'no_data'
      end
    end
  end
end
