require 'rails_helper'

RSpec.describe ElectricityCharges, type: :model do
  before do
    @charges_file = Rails.root.join('spec', 'test_data', 'charges.yml')
  end

  describe 'Logic tests' do
    context 'methods related to provider information' do
      it 'should return a provider information correctly' do
        @bill = ElectricityCharges.new(50, 50, @charges_file)
        expect(@bill.provider_name).to eq 'Test Provider'
        expect(@bill.plan_name).to eq 'Test Plan'
      end
    end

    context 'methods related to calculation' do
      it 'should calculate charges and change conditions correctly' do
        @bill = ElectricityCharges.new(50, 50, @charges_file)
        expect(@bill.calculate).to eq 1500
        expect(@bill.calculate).not_to eq 3500

        @bill = ElectricityCharges.new(60, 50, @charges_file)
        expect(@bill.calculate).to eq 2500
        expect(@bill.calculate).not_to eq 4500

        @bill = ElectricityCharges.new(50, 500, @charges_file)
        expect(@bill.calculate).to eq 26000
        expect(@bill.calculate).not_to eq 6000

        @bill = ElectricityCharges.new(60, 500, @charges_file)
        expect(@bill.calculate).to eq 27000
        expect(@bill.calculate).not_to eq 7000
      end

      it 'should show "no_data" when amp_numbers not matched with data' do
        @bill = ElectricityCharges.new(10, 50, @charges_file)
        expect(@bill.calculate).to eq 'no_data'
      end
    end
  end
end
