class Plan < ApplicationRecord
  belongs_to :company
  has_many :electricity_fees, dependent: :destroy
  has_many :basic_charges, dependent: :destroy

  def applicable_plan_fee(basic_charge, electricity_fee)
    basic_charge + electricity_fee
  end
end
