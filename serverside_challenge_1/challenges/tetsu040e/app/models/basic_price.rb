class BasicPrice < ApplicationRecord
  belongs_to :plan

  attribute :id, :integer
  attribute :plan_id, :integer
  attribute :ampere, :integer
  attribute :price, :float
end
