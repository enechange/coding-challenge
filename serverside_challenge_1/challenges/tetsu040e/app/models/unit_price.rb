class UnitPrice < ApplicationRecord
  belongs_to :plan

  attribute :id, :integer
  attribute :plan_id, :integer
  attribute :lower_usage_limit, :integer
  attribute :upper_usage_limit, :integer
  attribute :price, :float
end
