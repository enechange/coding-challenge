# frozen_string_literal: true

class ElectricityPlan < ApplicationRecord
  belongs_to :provider
  has_many :basic_rates, dependent: :destroy
  has_many :usage_rates, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :provider_id }

  def calculate_total_amount(amperage, usage_kwh)
    total_price = BigDecimal(0)

    # 基本料金
    total_price += basic_rates.find_rate_by_amperage(amperage)
    # 従量料金
    total_price += UsageRate.calculate_total(usage_kwh, usage_rates)

    total_price.floor
  end
end
