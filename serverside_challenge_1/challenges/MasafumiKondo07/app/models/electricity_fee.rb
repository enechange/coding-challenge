class ElectricityFee < ApplicationRecord
  belongs_to :plan

  def calc(amount_used)
    price * amount_used
  end
end
