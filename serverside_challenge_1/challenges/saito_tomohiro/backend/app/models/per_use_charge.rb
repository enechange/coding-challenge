class PerUseCharge < ApplicationRecord
  belongs_to :plan
  validates :min_usage, presence: true
  validates :max_usage, presence: true
  validates :per_use_charge, presence: true
end
