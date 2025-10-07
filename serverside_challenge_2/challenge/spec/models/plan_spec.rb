require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:provider) }
    it { is_expected.to have_many(:basic_fees).dependent(:destroy) }
    it { is_expected.to have_many(:usage_charges).dependent(:destroy) }
  end

  describe 'scopes' do
    describe '.by_ampere_and_usage' do
      subject { described_class.by_ampere_and_usage(ampere, usage) }

      let(:plan) { create(:plan) }

      context 'アンペアと使用量に該当するものがある場合/usage_chargesが一部ヒットする場合' do
        let(:ampere) { 30 }
        let(:usage) { 100 }

        let!(:basic_fee) { create(:basic_fee, plan:, ampere:) }
        let!(:usage_charge1) { create(:usage_charge, plan:, usage_lower: 0, usage_upper: usage) }
        let!(:usage_charge2) { create(:usage_charge, plan:, usage_lower: usage, usage_upper: usage + 1) }
        let!(:usage_charge3) { create(:usage_charge, plan:, usage_lower: usage + 1, usage_upper: usage + 2) } # not included

        it 'returns target plans and selected associations' do
          is_expected.to contain_exactly(plan)

          subject.first.tap do |p|
            expect(p.basic_fees).to contain_exactly(basic_fee)
            expect(p.usage_charges).to contain_exactly(usage_charge1, usage_charge2) # 正しく絞り込まれた状態で関連を取得できていること
          end
        end
      end

      context 'アンペアに該当するものがない場合' do
        let(:ampere) { 30 }
        let(:usage) { 100 }

        let!(:basic_fee) { create(:basic_fee, plan:, ampere: ampere + 1) }
        let!(:usage_charge) { create(:usage_charge, plan:, usage_lower: usage, usage_upper: usage + 1) }

        it 'returns an empty' do
          is_expected.to be_empty
        end
      end

      context '使用料に該当するものがない場合' do
        let(:ampere) { 30 }
        let(:usage) { 100 }

        let!(:basic_fee) { create(:basic_fee, plan:, ampere:) }
        let!(:usage_charge) { create(:usage_charge, plan:, usage_lower: usage + 1, usage_upper: nil) }

        it 'returns an empty' do
          is_expected.to be_empty
        end
      end
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '.plan_prices' do
    subject { described_class.plan_prices(ampere:, usage:) }

    before do
      provider1 = create(:provider, name: '東京電力エナジーパートナー')
      provider2 = create(:provider, name: '東京ガス')
      provider3 = create(:provider, name: 'Looopでんき')

      plan1 = create(:plan, name: '従量電灯B',     provider: provider1)
      plan2 = create(:plan, name: 'スタンダードS', provider: provider1)
      plan3 = create(:plan, name: 'ずっとも電気1', provider: provider2)
      plan4 = create(:plan, name: 'おうちプラン',  provider: provider3)

      create(:basic_fee, plan: plan1, ampere: 10, fee: 286.0)
      create(:basic_fee, plan: plan1, ampere: 30, fee: 858.00)
      create(:basic_fee, plan: plan1, ampere: 40, fee: 1144.00)

      create(:basic_fee, plan: plan2, ampere: 10, fee: 311.75)
      create(:basic_fee, plan: plan2, ampere: 30, fee: 935.25)
      create(:basic_fee, plan: plan2, ampere: 40, fee: 1247.00)

      # plan3は10Aの基本料金がないパターン
      create(:basic_fee, plan: plan3, ampere: 30, fee: 858.00)
      create(:basic_fee, plan: plan3, ampere: 40, fee: 1144.00)

      create(:basic_fee, plan: plan4, ampere: 10, fee: 0.00)
      create(:basic_fee, plan: plan4, ampere: 30, fee: 0.00)
      create(:basic_fee, plan: plan4, ampere: 40, fee: 0.00)

      create(:usage_charge, plan: plan1, usage_lower: 0,   usage_upper: 120, unit_price: 19.88)
      create(:usage_charge, plan: plan1, usage_lower: 120, usage_upper: 300, unit_price: 26.48)
      create(:usage_charge, plan: plan1, usage_lower: 300, usage_upper: nil, unit_price: 30.57)

      create(:usage_charge, plan: plan2, usage_lower: 0,   usage_upper: 120, unit_price: 29.80)
      create(:usage_charge, plan: plan2, usage_lower: 120, usage_upper: 300, unit_price: 36.40)
      create(:usage_charge, plan: plan2, usage_lower: 300, usage_upper: nil, unit_price: 40.49)

      create(:usage_charge, plan: plan3, usage_lower: 0,   usage_upper: 120, unit_price: 23.67)
      create(:usage_charge, plan: plan3, usage_lower: 120, usage_upper: 300, unit_price: 23.88)
      create(:usage_charge, plan: plan3, usage_lower: 300, usage_upper: nil, unit_price: 26.41)

      create(:usage_charge, plan: plan4, usage_lower: 0,   usage_upper: nil, unit_price: 28.8)
    end

    context 'アンペア10A、使用量120kWhの場合' do
      let(:ampere) { 10 }
      let(:usage) { 120 }

      it 'returns correct plan prices' do
        is_expected.to match_array([
          { provider_name: '東京電力エナジーパートナー', plan_name: '従量電灯B', price: 2671 }, # 286 + (19.88 * 120)
          { provider_name: '東京電力エナジーパートナー', plan_name: 'スタンダードS', price: 3887 }, # 311.75 + (29.80 * 120)
          { provider_name: 'Looopでんき', plan_name: 'おうちプラン', price: 3456 }, # 0 + (28.8 * 120)
        ])
      end
    end

    context 'アンペア30A、使用量120kWhの場合' do
      let(:ampere) { 30 }
      let(:usage) { 120 }

      it 'returns correct plan prices' do
          is_expected.to match_array([
            { provider_name: '東京電力エナジーパートナー', plan_name: '従量電灯B', price: 3243 }, # 858 + (19.88 * 120)
            { provider_name: '東京電力エナジーパートナー', plan_name: 'スタンダードS', price: 4511 }, # 935.25 + (29.80 * 120)
            { provider_name: '東京ガス', plan_name: 'ずっとも電気1', price: 3698 }, # 858 + (23.67 * 120)
            { provider_name: 'Looopでんき', plan_name: 'おうちプラン', price: 3456 }, # 0 + (28.8 * 120)
          ])
      end
    end

    context 'アンペア10A、使用量121kWhの場合' do
      # ※ ひとつのplanに対して、複数のusage_chargeが該当するパターン
      # 使用量の計算は段階的に計算されること
      let(:ampere) { 10 }
      let(:usage) { 121 }

      it 'returns correct plan prices' do
        is_expected.to match_array([
          { provider_name: '東京電力エナジーパートナー', plan_name: '従量電灯B', price: 2698 }, # 286 + (19.88 * 120) + (26.48 * 1)
          { provider_name: '東京電力エナジーパートナー', plan_name: 'スタンダードS', price: 3924 }, # 311.75 + (29.80 * 120) + (36.40 * 1)
          { provider_name: 'Looopでんき', plan_name: 'おうちプラン', price: 3484 }, # 0 + (28.8 * 121)
        ])
      end
    end

    context 'アンペア10A、使用量302kWhの場合' do
      let(:ampere) { 10 }
      let(:usage) { 302 }

      it 'returns correct plan prices' do
        is_expected.to match_array([
          { provider_name: '東京電力エナジーパートナー', plan_name: '従量電灯B', price: 7499 }, # 286 + (19.88 * 120) + (26.48 * 180) + (30.57 * 2)
          { provider_name: '東京電力エナジーパートナー', plan_name: 'スタンダードS', price: 10520 }, # 311.75 + (29.80 * 120) + (36.40 * 180) + (40.49 * 2)
          { provider_name: 'Looopでんき', plan_name: 'おうちプラン', price: 8697 }, # 0 + (28.8 * 302)
        ])
      end
    end

    context 'アンペア40A、使用量121kWhの場合' do
      let(:ampere) { 40 }
      let(:usage) { 121 }

      it 'returns correct plan prices' do
        is_expected.to match_array([
          { provider_name: '東京電力エナジーパートナー', plan_name: '従量電灯B', price: 3556 }, # 1144 + (19.88 * 120) + (26.48 * 1)
          { provider_name: '東京電力エナジーパートナー', plan_name: 'スタンダードS', price: 4859 }, # 1247.00 + (29.80 * 120) + (36.40 * 1)
          { provider_name: '東京ガス', plan_name: 'ずっとも電気1', price: 4008 }, # 1144 + (23.67 * 120) + (23.88 * 1)
          { provider_name: 'Looopでんき', plan_name: 'おうちプラン', price: 3484}, # 0 + (28.8 * 121)
        ])
      end
    end

    context '該当するアンペアがない場合' do
      let(:ampere) { 5 }
      let(:usage) { 120 }

      it 'returns an empty array' do
        is_expected.to be_empty
      end
    end

    context '該当する使用料がない場合' do
      let(:ampere) { 30 }
      let(:usage) { -1}

      it 'returns an empty array' do
        is_expected.to be_empty
      end
    end

    describe '異常系' do
      context 'アンペアがnilの場合' do
        let(:ampere) { nil }
        let(:usage) { 120 }

        it 'raises ArgumentError' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context '使用量がnilの場合' do
        let(:ampere) { 30 }
        let(:usage) { nil }

        it 'raises ArgumentError' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context 'アンペアがFloatの場合' do
        let(:ampere) { 30.5 }
        let(:usage) { 120 }

        it 'raises ArgumentError' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context '使用量がFloatの場合' do
        let(:ampere) { 30 }
        let(:usage) { 120.5 }

        it 'raises ArgumentError' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: plans
#
#  id            :bigint           not null, primary key
#  code          :string           not null
#  name          :string           not null
#  provider_code :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_plans_on_code           (code) UNIQUE
#  index_plans_on_provider_code  (provider_code)
#
# Foreign Keys
#
#  fk_rails_...  (provider_code => providers.code)
#
