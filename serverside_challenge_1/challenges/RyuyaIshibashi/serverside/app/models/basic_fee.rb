class BasicFee < ApplicationRecord
  belongs_to :plan
  with_options presence: true do
    validates :ampare
    validates :fee
  end
  scope :search_with_ampare, -> (ampare) { where(ampare: ampare) }

  def getCompanyName
    self.plan.company.name
  end

  def getPlanName
    self.plan.name
  end
end
