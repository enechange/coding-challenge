# 従量料金を計算するのに必要なデータを登録しているDBのモデル
class UsageCharge < ApplicationRecord
  belongs_to :company

  # 従量課金の計算を行う
  #
  # @param usage [Numeric] 使用量
  # @param tiers [Array<Hash>] 料金階層の配列
  # @return [Float] 従量課金の金額
  def self.calculate_charge(usage, tiers)
    charge = 0.0
    tiers.each_with_index do |tier, index|
      # 最後の計算
      if index == tiers.size - 1
        charge += (usage - tier[:prev_tier]) * tier[:fee].to_f
        break
      end

      # 計算の基本ロジック
      # tier [Integer] 区分上限値
      # prev_tier [Integer] 区分下限値
      # fee [Float] 区分毎の料金単価
      if usage <= tier[:tier]
        charge += (usage - tier[:prev_tier]) * tier[:fee].to_f
        break
      else
        charge += (tier[:tier] - tier[:prev_tier]) * tier[:fee].to_f
      end
    end
    charge
  end
end
