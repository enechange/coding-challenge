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

    # 最低使用量が引数の値よりも小さい料金を取得
    # 使用量が 0 から n の料金は min_usage が null で登録されているので、その料金も含める
    pay_as_you_go_fees.where('min_usage < ?', usage).or(pay_as_you_go_fees.where(min_usage: nil))
  end

  def calculate(ampere, usage)

    # 基本料金
    basic_charge = price
    if basic_charge.nil?
      basic_charge = basic_charges.find_by(ampere: ampere).price
    end

    # 従量料金
    fees = pay_as_you_go_fees_of_usage(usage).sum { |fee| fee.usage_price(usage) }

    # 基本料金 + 従量料金 小数点以下は切り捨て
    (basic_charge + fees).floor
  end
end
