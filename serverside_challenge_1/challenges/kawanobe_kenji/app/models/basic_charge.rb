class BasicCharge < ApplicationRecord
  belongs_to :plan

  validates :plan_id, presence: true
  validates :ampere, presence: true
  validates :charge, presence: true
end
