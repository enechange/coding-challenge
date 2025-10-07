require 'rails_helper'

RSpec.describe UsageCharge, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:plan) }
  end

  describe 'scopes' do
    describe '.lower_than' do
      subject { described_class.lower_than(usage) }

      let(:usage) { 100 }

      let!(:usage_charge_1) { create(:usage_charge, usage_lower: 0) }
      let!(:usage_charge_2) { create(:usage_charge, usage_lower: 99) }
      let!(:usage_charge_3) { create(:usage_charge, usage_lower: 100) }
      let!(:usage_charge_4) { create(:usage_charge, usage_lower: 101) }

      it 'returns usage charges that include the specified usage' do
        expect(subject).to contain_exactly(usage_charge_1, usage_charge_2, usage_charge_3)
      end
    end
  end

  describe '#calc_charge' do
    subject { usage_charge.calc_charge(usage) }

    context '使用量が0kWhの場合' do
      let(:usage_charge) { build(:usage_charge, usage_lower: 0, usage_upper: 120, unit_price: 19.88) }
      let(:usage) { 0 }

      it '0を返すこと' do
        expect(subject).to eq 0
      end
    end

    context '第1段階内での使用量の場合' do
      let(:usage_charge) { build(:usage_charge, usage_lower: 0, usage_upper: 120, unit_price: 19.88) }
      let(:usage) { 50 }

      it '期待される従量料金を返すこと' do
        expect(subject).to eq 994.0 # 19.88 * 50
      end
    end

    context '第1段階の上限を超える使用量の場合' do
      let(:usage_charge) { build(:usage_charge, usage_lower: 0, usage_upper: 120, unit_price: 19.88) }
      let(:usage) { 121 }

      it '期待される従量料金を返すこと' do
        expect(subject).to be_within(0.01).of(2385.6) # 19.88 * 120（上限）
      end
    end

    context '第2段階の境界値（下限-1）での使用量の場合' do
      let(:usage_charge) { build(:usage_charge, usage_lower: 120, usage_upper: 300, unit_price: 26.48) }
      let(:usage) { 119 }

      it '0を返すこと' do
        expect(subject).to eq 0.0
      end
    end

    context '第2段階の境界値（下限）での使用量の場合' do
      let(:usage_charge) { build(:usage_charge, usage_lower: 120, usage_upper: 300, unit_price: 26.48) }
      let(:usage) { 120 }

      it '0を返すこと' do
        expect(subject).to eq 0.0
      end
    end

    context '第2段階内での使用量の場合' do
      let(:usage_charge) { build(:usage_charge, usage_lower: 120, usage_upper: 300, unit_price: 26.48) }
      let(:usage) { 200 }

      it '期待される従量料金を返すこと' do
        expect(subject).to be_within(0.01).of(2118.4) # 26.48 * (200 - 120)
      end
    end

    context '第2段階の上限を超える使用量の場合' do
      let(:usage_charge) { build(:usage_charge, usage_lower: 120, usage_upper: 300, unit_price: 26.48) }
      let(:usage) { 301 }

      it '期待される従量料金を返すこと' do
        expect(subject).to be_within(0.01).of(4766.4) # 26.48 * (300 - 120)
      end
    end

    context '上限なしの段階での使用量の場合' do
      let(:usage_charge) { build(:usage_charge, usage_lower: 300, usage_upper: nil, unit_price: 26.48) }
      let(:usage) { 350 }

      it '期待される従量料金を返すこと' do
        expect(subject).to be_within(0.01).of(1324) # 26.48 * (350 - 300)
      end
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:usage_lower) }

    describe '#no_overlapping_ranges' do
      let(:plan) { create(:plan) }
      let!(:existing_charge) { create(:usage_charge, plan:, usage_lower: 100, usage_upper: 200) }


      shared_examples 'invalid' do
        it '重複しているため無効であること' do
          expect(new_charge).not_to be_valid
          expect(new_charge.errors[:base]).to include('overlapping usage range exists')
        end
      end

      shared_examples 'valid' do
        it '重複していないため有効であること' do
          expect(new_charge).to be_valid
        end
      end

      context '新規上限 = 既存下限 - 1' do
        let(:new_charge) { build(:usage_charge, plan:, usage_lower: 0, usage_upper: 99) }
        it_behaves_like 'valid'
      end

      context '新規上限 = 既存下限' do
        let(:new_charge) { build(:usage_charge, plan:, usage_lower: 0, usage_upper: 100) }
        it_behaves_like 'valid'
      end

      context '新規上限 = 既存下限 + 1' do
        let(:new_charge) { build(:usage_charge, plan:, usage_lower: 0, usage_upper: 101) }
        it_behaves_like 'invalid'
      end

      context '新規下限 = 既存上限 - 1' do
        let(:new_charge) { build(:usage_charge, plan:, usage_lower: 199, usage_upper: 300) }
        it_behaves_like 'invalid'
      end

      context '新規下限 = 既存上限' do
        let(:new_charge) { build(:usage_charge, plan:, usage_lower: 200, usage_upper: 300) }
        it_behaves_like 'valid'
      end

      context '新規下限 = 既存上限 + 1' do
        let(:new_charge) { build(:usage_charge, plan:, usage_lower: 201, usage_upper: 300) }
        it_behaves_like 'valid'
      end

      context '完全に同じ範囲の場合' do
        let(:new_charge) { build(:usage_charge, plan:, usage_lower: 100, usage_upper: 200) }
        it_behaves_like 'invalid'
      end

      context '既存範囲の中に含まれる場合' do
        let(:new_charge) { build(:usage_charge, plan:, usage_lower: 101, usage_upper: 199) }
        it_behaves_like 'invalid'
      end

      context '既存範囲の中に含む場合' do
        let(:new_charge) { build(:usage_charge, plan:, usage_lower: 99, usage_upper: 201) }
        it_behaves_like 'invalid'
      end

      context '別のプランに属する場合' do
        let(:new_charge) { build(:usage_charge, plan: create(:plan), usage_lower: 100, usage_upper: 200) }
        it_behaves_like 'valid'
      end

      context '既存の usage_upper が nil（上限なし）の場合' do
        let!(:existing_charge) { create(:usage_charge, plan:, usage_lower: 100, usage_upper: nil) }

        context '新規上限 = 既存下限 - 1' do
          let(:new_charge) { build(:usage_charge, plan:, usage_lower: 0, usage_upper: 99) }
          it_behaves_like 'valid'
        end

        context '新規上限 = 既存下限' do
          let(:new_charge) { build(:usage_charge, plan:, usage_lower: 0, usage_upper: 100) }
          it_behaves_like 'valid'
        end

        context '新規上限 = 既存下限 + 1' do
          let(:new_charge) { build(:usage_charge, plan:, usage_lower: 0, usage_upper: 101) }
          it_behaves_like 'invalid'
        end

        context '上限が存在せず下限が既存範囲より小さい場合（[99, nil]）' do
          let(:new_charge) { build(:usage_charge, plan:, usage_lower: 99, usage_upper: nil) }
          it_behaves_like 'invalid'
        end

        context '上限が存在せず下限が一致する場合（[100, nil]）' do
          let(:new_charge) { build(:usage_charge, plan:, usage_lower: 100, usage_upper: nil) }
          it_behaves_like 'invalid'
        end

        context '上限が存在せず下限が既存範囲より少し大きい場合（[101, nil]）' do
          let(:new_charge) { build(:usage_charge, plan:, usage_lower: 101, usage_upper: nil) }
          it_behaves_like 'invalid'
        end
      end

      context '新しい usage_upper が nil（上限なし）の場合' do
        let(:new_charge) { build(:usage_charge, plan:, usage_lower: 150, usage_upper: nil) }

        context '新規上限 = 既存下限 - 1' do
          let!(:existing_charge) { create(:usage_charge, plan:, usage_lower: 0, usage_upper: 149) }

          it_behaves_like 'valid'
        end

        context '新規上限 = 既存下限' do
          let!(:existing_charge) { create(:usage_charge, plan:, usage_lower: 0, usage_upper: 150) }

          it_behaves_like 'valid'
        end

        context '新規上限 = 既存下限 + 1' do
          let!(:existing_charge) { create(:usage_charge, plan:, usage_lower: 0, usage_upper: 151) }

          it_behaves_like 'invalid'
        end

        context '既存の usage_upper が nil で範囲が重なる場合（[149, nil]）' do
          let!(:existing_charge) { create(:usage_charge, plan:, usage_lower: 149, usage_upper: nil) }
          it_behaves_like 'invalid'
        end

        context '既存の usage_upper が nil で下限が一致する場合（[150, nil]）' do
          let!(:existing_charge) { create(:usage_charge, plan:, usage_lower: 150, usage_upper: nil) }
          it_behaves_like 'invalid'
        end

        context '既存の usage_upper が nil で下限が既存範囲より大きい場合（[151, nil]）' do
          let!(:existing_charge) { create(:usage_charge, plan:, usage_lower: 151, usage_upper: nil) }
          it_behaves_like 'invalid'
        end
      end
    end

    describe 'usage_upper is greater than usage_lower' do
      it 'is valid if usage_lower < usage_upper' do
        record = build(:usage_charge,
          usage_lower: 100,
          usage_upper: 101,
        )

        expect(record).to be_valid
      end

      it 'is invalid if usage_upper usage_lower > usage_upper' do
        record = build(:usage_charge,
          usage_lower: 100,
          usage_upper: 99,
        )

        expect(record).to be_invalid
      end

      it 'is invalid if usage_upper is usage_lower == usage_upper' do
        record = build(:usage_charge,
          usage_lower: 100,
          usage_upper: 100,
        )

        expect(record).to be_invalid
      end
    end
  end
end

# == Schema Information
#
# Table name: usage_charges
#
#  id                                :bigint           not null, primary key
#  code                              :string           not null
#  plan_code                         :string           not null
#  unit_price(従量料金単価(円/kWh))  :decimal(10, 2)   not null
#  usage_lower(電気使用量(kWh) 下限) :integer          not null
#  usage_upper(電気使用量(kWh) 上限) :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#
# Indexes
#
#  index_usage_charges_on_code                         (code) UNIQUE
#  index_usage_charges_on_plan_code_and_usage_range    (plan_code,usage_lower,usage_upper)
#  index_usage_charges_on_usage_lower_and_usage_upper  (usage_lower,usage_upper)
#
# Foreign Keys
#
#  fk_rails_...  (plan_code => plans.code)
#
