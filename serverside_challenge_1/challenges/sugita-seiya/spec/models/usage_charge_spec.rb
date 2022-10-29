require 'rails_helper'

RSpec.describe UsageCharge, type: :model do
  let(:provider) { create(:provider) }
  let(:plan) { create(:plan, electric_power_provider: provider) }

  describe "有効" do
    context "料金単価、区分(最小値、最大値)、プランに紐づくidが存在する場合" do
      subject { build(:usage_charge, electricity_rate_plan: plan) }

      it '有効であること' do
        expect(subject).to be_valid
      end
    end
  end

  describe "無効" do
    describe "料金単価" do
      context "存在しない場合" do
        subject { build(:usage_charge, charge_unit_price: nil, electricity_rate_plan: plan) }

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end

      context "0未満の場合" do
        subject { build(:usage_charge, charge_unit_price: -1, electricity_rate_plan: plan) }

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end
    end

    describe "区分の最小値" do
      context "存在しない場合" do
        subject { build(:usage_charge, minimum_usage: nil, electricity_rate_plan: plan) }

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end

      context "0未満の場合" do
        subject { build(:usage_charge, minimum_usage: -1, electricity_rate_plan: plan) }

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end

      context "少数の場合" do
        subject { build(:usage_charge, minimum_usage: 1.1, electricity_rate_plan: plan) }

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end

      context "同プラン内で、区分の最大値と最小値が同じ場合" do
        subject { build(:usage_charge, max_usage: 100, minimum_usage: 0, electricity_rate_plan: plan) }

        it '無効であること' do
            create(:usage_charge, max_usage: 100, minimum_usage: 0, electricity_rate_plan: plan)

            expect(subject.valid?).to be_falsey
        end
      end

      context "最大値より大きい数値の場合" do
        subject { build(:usage_charge, minimum_usage: 10, max_usage: 5, electricity_rate_plan: plan) }

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end
    end

    describe "プランに紐づくid" do
      context "存在しない場合" do
        subject { build(:usage_charge, electricity_rate_plan: nil) }

        it '無効である' do
          expect(subject.valid?).to be_falsey
        end
      end

    end
  end
end
