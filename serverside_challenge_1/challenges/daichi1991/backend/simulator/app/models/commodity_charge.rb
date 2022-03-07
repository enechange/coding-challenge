class CommodityCharge < ApplicationRecord
  belongs_to :plan
  validates :plan_id, presence: true
  validates :min_amount, presence: true
  validates :max_amount, presence: true
  validates :unit_price, presence: true

end
