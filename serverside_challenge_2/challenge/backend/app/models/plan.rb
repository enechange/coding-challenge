# frozen_string_literal: true

class Plan < ApplicationRecord
  belongs_to :provider
  has_many :electricity_charges_basic_rates, dependent: :destroy
  has_many :electricity_charges_usage_rates, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :provider_id }

  def electricity_price(ampere, usage)
    # アンペア数に対応する基本料金がなければ計算不能のためnilを返却する
    electricity_charges_basic_rate = electricity_charges_basic_rates.find_by(ampere: ampere)
    return nil if electricity_charges_basic_rate.nil?

    # 基本料金
    basic_price = electricity_charges_basic_rate.basic_rate

    # 従量料金
    usage_price = calc_usage_price(usage)

    # 電気料金（基本料金 + 従量料金）を返却
    (basic_price + usage_price).floor
  end

  private

  def calc_usage_price(usage)
    usage_rates = electricity_charges_usage_rates.order(:min_usage)

    usage_price = 0
    remaining_usage = usage

    usage_rates.each do |rate|
      # 使用量の上限がない場合、すべてその単価で計算
      if rate.max_usage.nil?
        usage_price += remaining_usage * rate.unit_rate
        break
      end

      # 範囲内の使用量のみ計算
      range_usage = [remaining_usage, rate.max_usage - rate.min_usage].min
      usage_price += range_usage * rate.unit_rate
      remaining_usage -= range_usage

      # 使用量が計算し終わったら終了
      break if remaining_usage <= 0
    end

    usage_price
  end
end
