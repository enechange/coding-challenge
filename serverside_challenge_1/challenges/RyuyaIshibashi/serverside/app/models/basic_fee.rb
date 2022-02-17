class BasicFee < ApplicationRecord
  belongs_to :plan
  with_options presence: true do
    validates :ampere
    validates :fee
  end

  def company_name
    self.plan.company.name
  end

  def getPlanName
    self.plan.name
  end
end
