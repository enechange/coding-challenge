class Plan < ApplicationRecord
  belongs_to :provider
  has_many :basic_rates
  has_many :usage_rates

  validates :name, presence: true

  # 指定されたアンペア数と使用量に基づいて電気料金を計算するメソッド
  # @param ampere [Integer] 契約アンペア数
  # @param usage_kwh [Integer] 1ヶ月の使用量(kWh)
  # @return [Integer] 計算された電気料金（円）
  def calculate_price(ampere, usage_kwh)
    basic_rate_price = basic_rates.find_by(ampere: ampere)&.price || 0
    return basic_rate_price if basic_rate_price.zero?
    usage_charge = UsageRate.calculate_charge(id, usage_kwh)
    (basic_rate_price + usage_charge).floor
  end

  # 指定されたアンペア数と使用量に基づいて、各プランの料金をシミュレートします。
  # @param ampere [Integer] 使用するアンペア数
  # @param usage_kwh [Float] 使用する電力量 (kWh)
  # @raise [ArgumentError] 指定されたアンペア数のプランが存在しない場合に発生します
  # @return [Array<Hash>] 各プランのプロバイダー名、プラン名、および計算された料金を含むハッシュの配列
  #
  def self.simulate(ampere, usage_kwh)
    Plan.includes(:provider, :basic_rates, :usage_rates).map do |plan|
      {
        provider_name: plan.provider.name,
        plan_name: plan.name,
        price: plan.calculate_price(ampere, usage_kwh)
      }
    end
  end

end
