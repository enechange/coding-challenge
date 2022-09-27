class PayAsYouGoFee < ApplicationRecord
  belongs_to :plan

  def usage_price(usage)

    # (総使用量 or この料金の最大使用量) - この料金の最低使用量 がこの料金における使用量
    # 総使用量が最大使用量を超えている場合は最大使用量を使って計算
    from = min_usage || 0
    to = max_usage.present? && max_usage < usage ? max_usage : usage
    usage_for_this_price = to - from

    price * usage_for_this_price
  end
end
