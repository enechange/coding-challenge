class Plan < ApplicationRecord
  belongs_to :provider
  has_many :basic_charges
  has_many :pay_as_you_go_fees

  # 指定のアンペアで契約可能なプラン
  scope :with_basic_charge, -> (ampere) {
    joins(:basic_charges).
      select('plans.*, basic_charges.ampere, basic_charges.price').
      where(basic_charges: {ampere: ampere})
  }

  def pay_as_you_go_fees_of_usage(usage)
    [
      # min, max が両方とも設定されている範囲の間
      pay_as_you_go_fees.find_by('min_usage < ? and ? <= max_usage', usage, usage),

      # min, max の片方しか設定されていない範囲の外側
      pay_as_you_go_fees.find_by('(? <= max_usage and min_usage is null) or (min_usage <= ? and max_usage is null)', usage, usage),

      # min, max の両方が未設定（全ての使用量で同じ料金）
      pay_as_you_go_fees.find_by(min_usage: nil, max_usage: nil)
    ].find { |record| !record.nil? }
  end

  def calculate(ampere, usage)
    basic_charge = basic_charges.find_by(ampere: ampere)
    pay_as_you_go_fee = pay_as_you_go_fees_of_usage(usage)

    # 基本料金 + (従量料金 * 利用 kWh) 小数点以下は切り捨て
    (basic_charge.price + (pay_as_you_go_fee.price * usage)).floor
  end
end
