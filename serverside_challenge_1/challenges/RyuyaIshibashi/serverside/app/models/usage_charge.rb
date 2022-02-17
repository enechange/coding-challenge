class UsageCharge < ApplicationRecord
  belongs_to :plan
  with_options presence: true do
    validates :from
    validates :unit_price
  end

  class << self
    def unit_price (plan_id, amount)
      # 使用料が0の場合は0を返す
      return 0 if amount == 0

      usageCharges = find_by_sql([
        'select usage_charges.*
        from usage_charges
        where (
          usage_charges.plan_id = :plan_id and
          ((usage_charges.to is not null and usage_charges.from < :amount and :amount <= usage_charges.to) or
           (usage_charges.to is null and usage_charges.from < :amount))
        )', {plan_id: plan_id, amount: amount}])

      # 該当するレコードが1件でなかった場合、アンマッチとしてnilを返す（複数件該当の場合も同様）
      return nil unless usageCharges.count == 1
      
      return usageCharges.first.unit_price
    end
  end
end
