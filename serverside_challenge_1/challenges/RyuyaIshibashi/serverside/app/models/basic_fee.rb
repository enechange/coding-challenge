class BasicFee < ApplicationRecord
  belongs_to :plan
  with_options presence: true do
    validates :ampare
    validates :fee
  end

  def getCompanyName
    self.plan.company.name
  end

  def getPlanName
    self.plan.name
  end

  class << self
    def getAmpareBasicFees (ampare)
      BasicFee.where(ampare: ampare)
    end
  end
end
