class BasicFee < ApplicationRecord
  belongs_to :plan
  with_options presence: true do
    validates :ampere
    validates :fee
  end
  scope :search_with_ampere, -> (ampere) { where(ampere: ampere) }

  def getCompanyName
    self.plan.company.name
  end

  def getPlanName
    self.plan.name
  end
end
