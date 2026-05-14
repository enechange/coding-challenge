# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Plan do
  describe 'バリデーション' do
    it 'name が空だと invalid になる' do
      record = build(:plan, name: nil)
      expect(record).not_to be_valid
      expect(record.errors[:name]).to be_present
    end

    it 'provider が nil だと invalid になる' do
      record = build(:plan, provider: nil)
      expect(record).not_to be_valid
      expect(record.errors[:provider]).to be_present
    end

    it 'slug が空だと invalid になる' do
      record = build(:plan, slug: nil)
      expect(record).not_to be_valid
      expect(record.errors[:slug]).to be_present
    end

    it 'slug が重複すると invalid になる' do
      create(:plan, slug: 'duplicated-slug')
      record = build(:plan, slug: 'duplicated-slug')
      expect(record).not_to be_valid
      expect(record.errors[:slug]).to be_present
    end
  end

  describe 'アソシエーション' do
    let(:plan) { create(:plan) }

    it 'belongs_to :provider が引ける' do
      expect(plan.provider).to be_a(Provider)
    end

    it 'has_many :ampere_based_rates が引ける' do
      create_list(:ampere_based_rate, 3, plan: plan)
      expect(plan.ampere_based_rates.size).to eq 3
    end

    it 'has_many :usage_based_rates が引ける' do
      create_list(:usage_based_rate, 2, plan: plan)
      expect(plan.usage_based_rates.size).to eq 2
    end
  end

  describe '#base_price_for' do
    let(:plan) { create(:plan) }

    context 'when 該当 ampere の rate が存在する' do
      before do
        create(:ampere_based_rate, plan: plan, ampere: 30, rate: '858.00')
        create(:ampere_based_rate, plan: plan, ampere: 40, rate: '1144.00')
      end

      it '該当 ampere の rate を返す' do
        expect(plan.base_price_for(30)).to eq BigDecimal('858.00')
      end
    end

    context 'when 該当 ampere の rate が 0 円で存在する (基本料金なしプラン)' do
      before do
        create(:ampere_based_rate, plan: plan, ampere: 30, rate: '0.00')
      end

      it 'BigDecimal(0) を返す' do
        expect(plan.base_price_for(30)).to eq BigDecimal(0)
      end
    end

    context 'when ampere_based_rates にレコードあり、ただし該当 ampere は未対応' do
      before do
        create(:ampere_based_rate, plan: plan, ampere: 30, rate: '858.00')
      end

      it 'nil を返す (プラン除外シグナル)' do
        expect(plan.base_price_for(20)).to be_nil
      end
    end
  end
end
