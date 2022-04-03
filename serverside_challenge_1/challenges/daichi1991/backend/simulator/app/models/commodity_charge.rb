class CommodityCharge < ApplicationRecord

  belongs_to :plan, foreign_key: "plan_code"
  validates :plan_code, presence: true
  validates :min_amount, presence: true
  validates :max_amount, presence: true
  validates :unit_price, presence: true

  # scope :plan_id, ->(get_plan_id) { where(plan_id: get_plan_id) }
  # scope :min_amount, ->(get_kw) { where('min_amount <= ?', get_kw) }
  # scope :max_amount, ->(get_kw) { where('max_amount >= ?', get_kw) }
  # scope :limit_one, -> { limit(1) }
  scope :commodity_charges_select, ->{select('commodity_charges.id','commodity_charges.min_amount','commodity_charges.max_amount','commodity_charges.unit_price')}
  scope :commodity_charges_where, ->(plan_code, get_kwh){where('plan_code = ?',plan_code).where('min_amount <= ?', get_kwh)}

  def self.calculate_commodity_charge(plan_code, get_kwh)
    records = get_commodity_record(plan_code, get_kwh)
    commodity_charges = calculate_step_price(records, get_kwh)
    return commodity_charges
  end
  

  def self.get_commodity_record(plan_code, get_kwh)
    records = commodity_charges_select.commodity_charges_where(plan_code,get_kwh)
  end

  def self.calculate_step_price(array, get_kwh)
    step_price = 0
    higher_amount = 0
    array.each do |a|
      if get_kwh.to_i > a['max_amount']
        higher_amount = a['max_amount']
      else
        higher_amount = get_kwh.to_i
      end
        step_price = (higher_amount - a['min_amount']+1) * a['unit_price'].to_f + step_price
    end
    return step_price
  end

end
