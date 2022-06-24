class BasicFee < ApplicationRecord
  belongs_to :plan

  with_options presence: true do
    validates :ampere
    validates :base_fee
  end
end
