class Plan < ApplicationRecord
  has_many :basic_charges
  has_many :commodity_charges

  validates :provider_name, presence: true
  validates :plan, presence: true
  

  scope :select_plan, -> { select('plans.id, plans.provider_name, plans.plan, basic_charges.charge, commodity_charges.unit_price')}
  scope :basic_charges, -> { joins(:basic_charges)}
  scope :commodity_charges, -> { joins(:commodity_charges)}

  scope :join_tables, -> {select_plan.basic_charges.commodity_charges}

  scope :ampere, -> (get_ampere){where(basic_charges: {ampere: get_ampere})}
  scope :min_amount, -> (get_kwh){where('min_amount <= ?', get_kwh)}
  scope :max_amount, -> (get_kwh){where('max_amount >= ?', get_kwh)}
  
  
end
