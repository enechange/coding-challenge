# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Provider, type: :model do
  describe '#electricity_prices' do
    let(:provider) { create(:provider, name: '東京電力エナジーパートナー') }

    context '対象アンペアが全プランで存在する場合' do
      let(:ampere) { 20 }
      let(:usage) { 100 }
      let!(:plan1) { create(:plan, provider: provider, name: '従量電灯B') }
      let!(:plan2) { create(:plan, provider: provider, name: 'スタンダードS') }

      before do
        # plan1 20Aの価格設定あり
        create(:electricity_charges_basic_rate, plan: plan1, ampere: 20, basic_rate: 572.00)
        create(:electricity_charges_usage_rate, plan: plan1, min_usage: 0, max_usage: 120, unit_rate: 19.88)

        # plan2 20Aの価格設定あり
        create(:electricity_charges_basic_rate, plan: plan2, ampere: 20, basic_rate: 672.00)
        create(:electricity_charges_usage_rate, plan: plan2, min_usage: 0, max_usage: 120, unit_rate: 29.88)
      end

      it 'すべてのプランが返る' do
        result = provider.electricity_prices(ampere, usage)

        expect(result).to eq([
                               {
                                 provider_name: '東京電力エナジーパートナー',
                                 plan_name: '従量電灯B',
                                 price: plan1.electricity_price(ampere, usage)
                               },
                               {
                                 provider_name: '東京電力エナジーパートナー',
                                 plan_name: 'スタンダードS',
                                 price: plan2.electricity_price(ampere, usage)
                               }
                             ])
      end
    end

    context '対象アンペアが存在するプランとしないプランで混在する場合' do
      let(:ampere) { 20 }
      let(:usage) { 100 }
      let!(:plan1) { create(:plan, provider: provider, name: '従量電灯B') }
      let!(:plan2) { create(:plan, provider: provider, name: 'スタンダードS') }

      before do
        # plan1 20Aの価格設定あり
        create(:electricity_charges_basic_rate, plan: plan1, ampere: 20, basic_rate: 572.00)
        create(:electricity_charges_usage_rate, plan: plan1, min_usage: 0, max_usage: 120, unit_rate: 19.88)

        # plan2 30Aの価格設定あり
        create(:electricity_charges_basic_rate, plan: plan2, ampere: 30, basic_rate: 672.00)
        create(:electricity_charges_usage_rate, plan: plan2, min_usage: 0, max_usage: 120, unit_rate: 29.88)
      end

      it '対象アンペアが存在するプランのみが返る' do
        result = provider.electricity_prices(ampere, usage)

        expect(result).to eq([
                               {
                                 provider_name: '東京電力エナジーパートナー',
                                 plan_name: '従量電灯B',
                                 price: plan1.electricity_price(ampere, usage)
                               }
                             ])
      end
    end

    context '対象アンペアが全プランで存在しない場合' do
      let(:ampere) { 11 }
      let(:usage) { 100 }
      let!(:plan1) { create(:plan, provider: provider, name: '従量電灯B') }
      let!(:plan2) { create(:plan, provider: provider, name: 'スタンダードS') }

      before do
        # plan1 20Aの価格設定あり
        create(:electricity_charges_basic_rate, plan: plan1, ampere: 20, basic_rate: 572.00)
        create(:electricity_charges_usage_rate, plan: plan1, min_usage: 0, max_usage: 120, unit_rate: 19.88)

        # plan2 30Aの価格設定なし
        create(:electricity_charges_basic_rate, plan: plan2, ampere: 30, basic_rate: 672.00)
        create(:electricity_charges_usage_rate, plan: plan2, min_usage: 0, max_usage: 120, unit_rate: 29.88)
      end

      it '対象アンペアが存在するプランのみが返る' do
        result = provider.electricity_prices(ampere, usage)

        expect(result).to eq([])
      end
    end
  end
end
