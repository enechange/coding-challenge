class BaseCharge < ApplicationRecord
  belongs_to :plan
  validates :ampere, presence: true
  validates :base_charge, presence: true
end
