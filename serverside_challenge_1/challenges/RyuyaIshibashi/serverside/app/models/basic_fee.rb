class BasicFee < ApplicationRecord
  belongs_to :plan
  with_options presence: true do
    validates :ampare
    validates :fee
  end
end
