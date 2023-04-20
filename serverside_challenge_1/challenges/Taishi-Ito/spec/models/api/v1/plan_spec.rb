require 'rails_helper'

RSpec.describe Api::V1::Plan, type: :model do
  describe 'basic_charge method' do
    let(:plan) { Api::V1::Plan.find(1) }
    context "ampere is 50" do
      it "should be 1430.00" do
        expect(plan.basic_charge(50)).to eq 1430.00
      end
    end

    context "ampere is 100" do
      it "should be nil" do
        expect(plan.basic_charge(100)).to eq nil
      end
    end
  end

  describe 'usage_charge method' do
    let(:plan) { Api::V1::Plan.find(1) }
    context "kwh is 50" do
      it "should be 994" do
        expect(plan.usage_charge(50)).to eq 994
      end
    end

    context "kwh is 130" do
      it "should be 5828.0" do
        expect(plan.usage_charge(130)).to eq 5828.0
      end
    end

    context "kwh is 500" do
      it "should be 22437.0" do
        expect(plan.usage_charge(500)).to eq 22437.0
      end
    end

    context "kwh is 0.5" do
      it "should be 0.00" do
        expect(plan.usage_charge(0.5)).to eq 0.00
      end
    end
  end
end
