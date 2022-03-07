class BasicCharge < ApplicationRecord
  belongs_to :plan
  validates :plan_id, presence: true
  validates :ampere, presence: true
  validates :charge, presence: true

  def index_from_charge(ampere)
    basic_charge = self.where(ampere: ampere)
    return basic_charge
  end
  
end
