class UsageCharge < ApplicationRecord
  belongs_to :electricity_rate_plan

  validates :charge_unit_price,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  validates :minimum_usage,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 },
            uniqueness: { scope: [:electricity_rate_plan_id, :max_usage] }

  validates :max_usage,
            presence: true,
            # 「法人のひと月の電気使用量30,000kWh」と例示されており、「99999/月」を超える電気使用量の
            # リクエストは無いと想定し、最大値を「99999」に設定
            # 参照先：https://miraiz.chuden.co.jp/business/electric/contract/factory/hi_price/calcexample/index.html
            numericality: { less_than_or_equal_to: 99999 }

  validates :electricity_rate_plan_id,
            presence: true
end
