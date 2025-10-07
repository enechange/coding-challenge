class Plan < ApplicationRecord
  belongs_to :provider, primary_key: :code, foreign_key: :provider_code
  has_many :basic_fees, dependent: :destroy, primary_key: :code, foreign_key: :plan_code
  has_many :usage_charges, dependent: :destroy, primary_key: :code, foreign_key: :plan_code

  validates :name, presence: true

  # 契約アンペア数と電気使用量に基づき、該当する料金プランの一覧を取得する
  # @param ampere [Integer] 契約アンペア数(A)
  # @param usage [Integer] 電気使用量(kWh)
  # @return [ActiveRecord::Relation<Plan>]
  scope :by_ampere_and_usage, ->(ampere, usage) do
    joins(:basic_fees, :usage_charges)
      .includes(:provider, :basic_fees, :usage_charges)
      .merge(BasicFee.by_ampere(ampere))
      .merge(UsageCharge.lower_than(usage))
      .distinct
  end

  # 契約アンペア数と電気使用量に基づき、該当する料金プランの一覧と料金を取得する
  # @param ampere [Integer] 契約アンペア数(A)
  # @param usage [Integer] 電気使用量(kWh)
  # @return [Array<Hash>] [{ provider_name: ‘Looopでんき’, plan_name: ‘おうちプラン’, price: ‘1234’ }, …]
  def self.plan_prices(ampere:, usage:)
    raise ArgumentError, 'ampere must be an Integer' unless ampere.is_a?(Integer)
    raise ArgumentError, 'usage must be an Integer' unless usage.is_a?(Integer)

    plans = self.by_ampere_and_usage(ampere, usage)
    plans.map do |plan|
      basic_fee = plan.basic_fees.sole # 基本料金は契約アンペア数に対して1つだけ存在する想定
      usage_charges = plan.usage_charges # すでに絞り込まれている想定

      {
        provider_name: plan.provider.name,
        plan_name: plan.name,
        price: self.calc_price(basic_fee:, usage_charges:, usage:),
      }
    end
  end

  private

  # 電気料金 = ①基本料金 + ②従量料金 + ③そのほか
  # NOTE: 現時点では③そのほかは考慮しない
  # NOTE: もし他の箇所で同じように料金を計算する必要が出てきた場合や、そのほかを計算し複雑化する場合は、電気料金の値オブジェクト化を検討すること
  # @param basic_fee [BasicFee] 基本料金オブジェクト
  # @param usage_charges [Array<UsageCharge>] 従量料金オブジェクトの配列
  # @param usage [Integer] 電気使用量(kWh)
  # @return [Integer] 合計電気料金 (円)
  def self.calc_price(basic_fee:, usage_charges:, usage:)
    fee = basic_fee.fee
    total_charge = usage_charges.sum { |uc| uc.calc_charge(usage) }
    (fee + total_charge).floor
  end
end

# == Schema Information
#
# Table name: plans
#
#  id            :bigint           not null, primary key
#  code          :string           not null
#  name          :string           not null
#  provider_code :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_plans_on_code           (code) UNIQUE
#  index_plans_on_provider_code  (provider_code)
#
# Foreign Keys
#
#  fk_rails_...  (provider_code => providers.code)
#
