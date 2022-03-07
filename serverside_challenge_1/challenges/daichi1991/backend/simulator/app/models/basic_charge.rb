class BasicCharge < ApplicationRecord
  belongs_to :plan

  def index_from_charge(ampere)
    basic_charge = self.where(ampere: ampere)
    return basic_charge
  end
  
end
