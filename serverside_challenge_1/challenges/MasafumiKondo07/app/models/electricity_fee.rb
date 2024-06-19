class ElectricityFee < ApplicationRecord
  belongs_to :plan
  class << self
    def calc(plan, amount_used)
      result = 0
      plan.electricity_fees.where(classification_min: ..amount_used).each do |instance|
        usage_lower_limit = instance.classification_min == 0 ? 0 : instance.classification_min - 1
        usage_upper_limit = instance.classification_max.present? && instance.classification_max < amount_used ? instance.classification_max : amount_used
        result += (usage_upper_limit - usage_lower_limit) * instance.price
      end
      result
    end
  end
end
