# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProviderService do
  let(:ampere_under_30) { 20 }
  let(:ampere_over_30) { 40 }
  let(:usage) { 100 }

  describe '.calculate' do
    context 'アンペア30未満の場合' do
      it 'TokyoElectricとLoopの結果のみを返す' do
        expect(ProviderService.calculate(ampere_under_30, usage)).to include(:tokyo_electric, :loop)
        expect(ProviderService.calculate(ampere_under_30, usage)).not_to include(:tokyo_gas, :jxtg)
      end
    end

    context 'アンペア30以上の場合' do
      it '全プロバイダーの結果を返す' do
        expect(ProviderService.calculate(ampere_over_30, usage)).to include(:tokyo_electric, :loop, :tokyo_gas, :jxtg)
      end
    end
  end

  describe '.providers_info' do
    context 'アンペア30未満の場合' do
      it 'TokyoElectricとLoopの結果のみを返す' do
        expect(ProviderService.providers_info(ampere_under_30)).to include(:tokyo_electric, :loop)
        expect(ProviderService.providers_info(ampere_under_30)).not_to include(:tokyo_gas, :jxtg)
      end
    end

    context 'アンペア30以上の場合' do
      it '全プロバイダーの結果を返す' do
        expect(ProviderService.providers_info(ampere_over_30)).to include(:tokyo_electric, :loop, :tokyo_gas, :jxtg)
      end
    end
  end
end
