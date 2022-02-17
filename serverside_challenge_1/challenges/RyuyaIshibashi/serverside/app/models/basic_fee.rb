class BasicFee < ApplicationRecord
  belongs_to :plan
  with_options presence: true do
    validates :ampere
    validates :fee
  end

  def company_name
    self.plan.company.name
  end

  def plan_name
    self.plan.name
  end
end
