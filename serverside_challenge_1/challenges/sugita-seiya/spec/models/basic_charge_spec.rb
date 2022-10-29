require 'rails_helper'

RSpec.describe BasicCharge, type: :model do
  let(:provider) { create(:provider) }
  let(:plan) { create(:plan, electric_power_provider: provider) }

  describe "有効" do
    context "アンペア数、料金単価、プランに紐づくidが存在する場合" do
      subject { build(:basic_charge, electricity_rate_plan: plan) }

      it '有効であること' do
        expect(subject).to be_truthy
      end
    end
  end

  describe "無効" do
    describe "アンペア" do
      context "存在しない場合" do
        subject { build(:basic_charge, contract_amperage: nil, electricity_rate_plan: plan) }

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end

      context "[10, 15, 20, 30, 40, 50, 60]に該当しない場合" do
        subject { build(:basic_charge, contract_amperage: nil, electricity_rate_plan: plan) }

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end

      context "アンペア数とプランが重複する場合" do
        subject { build(:basic_charge, electricity_rate_plan: plan) }

        it '無効であること' do
          create(:basic_charge, electricity_rate_plan: plan)

          expect(subject.valid?).to be_falsey
        end
      end
    end

    describe "料金単価" do
      context "存在しない場合" do
        subject { build(:basic_charge, charge_unit_price: nil, electricity_rate_plan: plan) }

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end

      context "0未満の場合" do
        subject { build(:basic_charge, charge_unit_price: -1, electricity_rate_plan: plan) }

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end
    end

    describe "基本料金に紐づくプラン" do
      context "存在しない場合" do
        subject { build(:basic_charge) }

        it '無効であること' do
          expect(subject.valid?).to be_falsey
        end
      end
    end
  end
end
