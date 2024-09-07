# frozen_string_literal: true

# == Schema Information
#
# Table name: electricity_usages
#
#  id                               :bigint           not null, primary key
#  from(電気使用量(開始値))         :integer          default(0), not null
#  to(電気使用量時(終了値))         :integer          default(0)
#  unit_price(従量料金単価(円/kWh)) :money            default(0.0), not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  plan_id                          :bigint           not null
#
# Indexes
#
#  index_electricity_usages_on_plan_id  (plan_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#
require 'rails_helper'

RSpec.describe ElectricityUsage, type: :model do
  describe '#validate' do
    let(:plan) { create(:plan) }
    let(:from) { 100 }
    let(:to) { 200 }
    before { create(:electricity_usage, from:, to:, plan:) }

    context '別のplan と紐づく場合' do
      it '同一の電気使用量でもvalidation エラーとならないこと' do
        electricity_usage = build(:electricity_usage, from:, to:)
        expect(electricity_usage.valid?).to eq true
      end
    end

    context '同一のplan と紐づく場合' do
      context '電気使用量に全く同じ範囲のデータが登録されようとする場合' do
        it 'validation エラーとなること' do
          electricity_usage = build(:electricity_usage, from:, to:, plan:)
          expect(electricity_usage.valid?).to eq false
        end
      end

      context '電気使用量の開始値が同じ値のデータで登録されようとする場合' do
        it 'validation エラーとなること' do
          electricity_usage = build(:electricity_usage, from:, to: 250, plan:)
          expect(electricity_usage.valid?).to eq false
        end
      end

      context '電気使用量の終了値が同じ値のデータで登録されようとする場合' do
        it 'validation エラーとなること' do
          electricity_usage = build(:electricity_usage, from: 90, to:, plan:)
          expect(electricity_usage.valid?).to eq false
        end
      end

      context '電気使用量の範囲が重複するデータで登録されようとする場合' do
        it 'validation エラーとなること' do
          electricity_usage = build(:electricity_usage, from: 110, to: 190, plan:)
          expect(electricity_usage.valid?).to eq false
        end
      end

      context '終端値が nil の場合で開始値の範囲が重複する場合' do
        it 'validation エラーとなること' do
          electricity_usage = build(:electricity_usage, from: 110, to: nil, plan:)
          expect(electricity_usage.valid?).to eq false
        end
      end

      context '範囲が一切重ならない場合' do
        it 'validation エラーとならないこと' do
          electricity_usage = build(:electricity_usage, from: 201, to: 300, plan:)
          expect(electricity_usage.valid?).to eq true
        end
      end

      context '終端値がnil である場合' do
        it 'validation エラーとならないこと' do
          electricity_usage = build(:electricity_usage, from: 201, to: nil, plan:)
          expect(electricity_usage.valid?).to eq true
        end
      end

      context '複数登録されており、ちょうど間の値を登録する場合' do
        before { create(:electricity_usage, from: 301, to: nil, plan:) }

        it 'validation エラーとならないこと' do
          electricity_usage = build(:electricity_usage, from: 201, to: 300, plan:)
          expect(electricity_usage.valid?).to eq true
        end
      end
    end
  end
end
