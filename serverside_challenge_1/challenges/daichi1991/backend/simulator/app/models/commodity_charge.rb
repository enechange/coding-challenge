class CommodityCharge < ApplicationRecord
  belongs_to :plan
  validates :plan_id, presence: true
  validates :min_amount, presence: true
  validates :max_amount, presence: true
  validates :unit_price, presence: true

  scope :plan_id, ->(get_plan_id) { where(plan_id: get_plan_id) }
  scope :min_amount, ->(get_kw) { where('min_amount <= ?', get_kw) }
  scope :max_amount, ->(get_kw) { where('max_amount >= ?', get_kw) }
  scope :limit_one, -> { limit(1) }
end
