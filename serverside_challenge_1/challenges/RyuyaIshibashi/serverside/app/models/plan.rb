class Plan < ApplicationRecord
  belongs_to :company
  
  has_many :basic_fees
  has_many :usage_charges

  validates :id, presence: true, uniqueness: true
  validates :name, presence: true

  scope :basic_fee_ampere, -> (ampere) {
    joins(:basic_fees)
      .select('plans.*, basic_fees.fee AS basic_fee')
      .where(basic_fees: { ampere: ampere })
  }
end
