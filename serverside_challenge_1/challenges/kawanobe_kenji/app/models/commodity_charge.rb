class CommodityCharge < ApplicationRecord
  belongs_to :plan

  validates :plan_id, presence: true
  validates :kwh_from, presence: true
  validates :charge, presence: true
end
