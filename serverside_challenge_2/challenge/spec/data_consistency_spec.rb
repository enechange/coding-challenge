# frozen_string_literal: true

require 'rails_helper'

# 単体テスト (model spec / service spec) で代替できない、
# 「複数レコード間 / 全プラン横断」の invariant のみをここで検証する。
#
# 「個別レコードが valid」「個別 validation が動作する」は seeds.rb 内の
# save! / update! / find_or_create_by! が validation 経由で例外を出すため、
# seed が成功した時点で自動的に保証される (model spec でも検証済み)。
RSpec.describe 'シードデータの整合性' do
  before { Rails.application.load_seed }

  describe '入力可能範囲のカバレッジ' do
    it '各プラン最終段の kilowatt_hour_high が MAX_KWH 以上であること' do
      Plan.find_each do |plan|
        last_high = plan.usage_based_rates.maximum(:kilowatt_hour_high)
        expect(last_high).to be >= ElectricityBillConstants::MAX_KWH,
                             "Plan '#{plan.name}': 最終段 #{last_high} が " \
                             "MAX_KWH (#{ElectricityBillConstants::MAX_KWH}) 未満。" \
                             '入力受付した kwh が料金計算でカバーされない可能性がある (silent な料金過小算出のリスク)'
      end
    end
  end

  describe '料金レンジの連続性' do
    it '各プランの usage_based_rates の最初の段は low=0 から始まる' do
      Plan.find_each do |plan|
        sorted = plan.usage_based_rates.order(:kilowatt_hour_low)
        next if sorted.empty?

        first_low = sorted.first.kilowatt_hour_low
        expect(first_low).to eq(0), "Plan##{plan.id}: 最初の段の low は 0 のはずが #{first_low}"
      end
    end

    it '各プランの usage_based_rates は段の間に穴も重複もなく境界値を共有して連続している' do
      Plan.find_each do |plan|
        ranges = plan.usage_based_rates.order(:kilowatt_hour_low).pluck(:kilowatt_hour_low, :kilowatt_hour_high)
        ranges.each_cons(2) do |(_, prev_high), (next_low, _)|
          expect(next_low).to eq(prev_high)
        end
      end
    end
  end
end
