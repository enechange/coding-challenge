class BasicFee < ApplicationRecord
  belongs_to :plan
  with_options presence: true do
    validates :ampare
    validates :fee
  end

  class << self
    def getAmpareBasicFees (ampare)
      BasicFee.where(ampare: ampare)
    end
  end
end
