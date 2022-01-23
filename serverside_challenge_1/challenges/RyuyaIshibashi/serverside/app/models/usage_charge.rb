class UsageCharge < ApplicationRecord
  belongs_to :plan
  with_options presence: true do
    validates :from
    validates :unit_price
  end
end
