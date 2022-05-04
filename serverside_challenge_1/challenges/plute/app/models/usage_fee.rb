class UsageFee < ApplicationRecord
  belongs_to :plan

  validates :min_usage, presence: true
  validates :max_usage, presence: true
  validates :unit_usage_fee, presence: true, uniqueness: { scope: [:plan_id, :min_usage, :max_usage] }
  validate :valid_min_max

  private

  def valid_min_max
    errors.add :base, "min_usage must be smaller than max_usage " if min_usage > max_usage
  end
end
