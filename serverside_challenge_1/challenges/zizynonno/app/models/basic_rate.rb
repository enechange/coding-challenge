class BasicRate < ApplicationRecord
  belongs_to :electricity_plan

  validates :ampere, inclusion: { in: [10, 15, 20, 30, 40, 50, 60], message: "%{value} のサイズは無効です" }
end
