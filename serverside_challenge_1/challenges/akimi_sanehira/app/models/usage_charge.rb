class UsageCharge < ApplicationRecord
  belongs_to :plan

  with_options presence: true do
    validates :min_usage
    validates :unit_usage_fee
  end
end
