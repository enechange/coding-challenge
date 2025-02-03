require 'rails_helper'

RSpec.describe ElectricityFee, type: :model do
  before do
    company = FactoryBot.create(:company)
    @plan = FactoryBot.create(:plan, company_id: company.id)
    FactoryBot.create(:electricity_fee, plan_id: @plan.id, classification_min: 0, classification_max: 120, price: 19.88)
    FactoryBot.create(:electricity_fee, plan_id: @plan.id, classification_min: 121, classification_max: 300, price: 26.48)
    FactoryBot.create(:electricity_fee, plan_id: @plan.id, classification_min: 301, classification_max: nil, price: 30.57)
  end

  describe '#calc' do
    context "60" do
      # 19.88 * 60 = 1192.8
      it "returns 1192.8" do
        expect(ElectricityFee.calc(@plan, 60)).to eq(1192.8)
      end
    end

    context "Boundary value 120" do
      # 19.88 * 120 = 2385.6
      it "returns 2385.6" do
        expect(ElectricityFee.calc(@plan, 120)).to eq(2385.6)
      end
    end

    context "Boundary value 121" do
      # (19.88 * 120) + (26.48 * (121 - 120)) = 2412.08
      it "returns 2412.08" do
        expect(ElectricityFee.calc(@plan, 121)).to eq(2412.08)
      end
    end

    context "Boundary value 300" do
      # (19.88 * 120) + (26.48 * (300 - 120)) = 7152
      it "returns 7152" do
        expect(ElectricityFee.calc(@plan, 300)).to eq(7152)
      end
    end

    context "Boundary value 301" do
      # (19.88 * 120) + (26.48 * (300 - 120)) + (30.57 * (301 - 300)) = 7182.57
      it "returns 7182.57" do
        expect(ElectricityFee.calc(@plan, 301)).to eq(7182.57)
      end
    end

    context "600" do
      # (19.88 * 120) + (26.48 * (300 - 120)) + (30.57 * (600 - 300)) = 16323
      it "returns 16323" do
        expect(ElectricityFee.calc(@plan, 600)).to eq(16323)
      end
    end
  end
end
