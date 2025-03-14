# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElectricityChargesUsageRate, type: :model do
  let(:provider) { create(:provider) }
  let(:plan) { create(:plan, provider: provider) }

  describe 'バリデーション' do
    describe '正常系' do
      context '使用量の範囲が他と重複していない場合' do
        it 'バリデーションが通る' do
          rate1 = build(:electricity_charges_usage_rate, plan: plan, min_usage: 0, max_usage: 120)
          rate2 = build(:electricity_charges_usage_rate, plan: plan, min_usage: 121, max_usage: 300)

          expect(rate1).to be_valid
          expect(rate2).to be_valid
        end
      end

      context '使用量の上限がnilで、他のデータと重複していない場合' do
        it 'バリデーションが通る' do
          rate1 = build(:electricity_charges_usage_rate, plan: plan, min_usage: 0, max_usage: 120)
          rate2 = build(:electricity_charges_usage_rate, plan: plan, min_usage: 121, max_usage: nil)

          expect(rate1).to be_valid
          expect(rate2).to be_valid
        end
      end
    end

    describe '異常系' do
      context '同一プラン内で使用量の範囲が重複する場合' do
        before do
          create(:electricity_charges_usage_rate, plan: plan, min_usage: 0, max_usage: 120)
        end

        it 'バリデーションエラーが発生する' do
          overlapping_rate = build(:electricity_charges_usage_rate, plan: plan, min_usage: 100, max_usage: 200)
          expect(overlapping_rate).to be_invalid
          expect(overlapping_rate.errors[:base]).to include('同一プラン内で使用量の範囲が他のレコードと重複しています')
        end
      end

      context '同一プラン内で使用量上限がnilのデータが複数存在する場合' do
        before do
          create(:electricity_charges_usage_rate, plan: plan, min_usage: 121, max_usage: nil)
        end

        it 'バリデーションエラーが発生する' do
          duplicate_max_nil = build(:electricity_charges_usage_rate, plan: plan, min_usage: 301, max_usage: nil)
          expect(duplicate_max_nil).to be_invalid
          expect(duplicate_max_nil.errors[:base]).to include('同一プラン内で使用量上限がない項目が2つ以上存在します')
        end
      end
    end
  end
end
