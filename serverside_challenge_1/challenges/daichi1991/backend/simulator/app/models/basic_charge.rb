class BasicCharge < ApplicationRecord
  belongs_to :plan, foreign_key: "plan_code"
  validates :plan_code, presence: true
  validates :ampere, presence: true
  validates :charge, presence: true
end
