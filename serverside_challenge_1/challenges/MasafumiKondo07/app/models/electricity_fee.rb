class ElectricityFee < ApplicationRecord
  belongs_to :plan

  def calc(amount_used)
    target_electricity_fees = self.class.where(plan_id: plan_id).order(classification_min: :asc)
    result = 0
    target_electricity_fees.each do |instance|
      break if (amount_used < instance.classification_min)
      usage_lower_limit = instance.classification_min == 0 ? 0 : instance.classification_min - 1
      usage_upper_limit = instance.classification_max.present? && instance.classification_max < amount_used ? instance.classification_max : amount_used
      result += (usage_upper_limit - usage_lower_limit) * instance.price
    end
    result
  end
end
