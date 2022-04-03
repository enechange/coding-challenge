class Plan < ApplicationRecord

  belongs_to :provider, foreign_key: "provider_code"
  has_many :basic_charges, dependent: :destroy, foreign_key: "plan_code"
  has_many :commodity_charges, dependent: :destroy, foreign_key: "plan_code"

  validates :plan_code, presence: true
  validates :plan_name, presence: true
  validates :provider_code, presence: true
  

  scope :select_plan, lambda {
                        select('plans.plan_code,
                          providers.provider_name,
                          plans.plan_name,
                          basic_charges.charge,
                          commodity_charges.unit_price')
                        .joins(:provider).distinct
                        .joins(:basic_charges)
                        .joins(:commodity_charges)
                      }
  scope :extraction_condition, ->(get_ampere, get_kwh) { 
                        where(basic_charges: { ampere: get_ampere })
                        .where('min_amount <= ?', get_kwh)
                        .where('max_amount >= ?', get_kwh) 
                      }

  def self.get_data(get_ampere, get_kwh)
    records = select_plan.extraction_condition(get_ampere,get_kwh)
    records = record_to_hash(records)
    records = calculate_step_price(records, get_kwh)
    records = calculate_price(records)
    records =array_sort(records)
    return records.map { |r| [r['provider_name'],r['plan_name'],r['price']] }
  end

  def self.record_to_hash(records)
    records.map(&:attributes)
  end

  def self.calculate_step_price(array, get_kwh)
    count = 0  
    array.each do |a|
      step_price = CommodityCharge.calculate_commodity_charge(a['plan_code'], get_kwh)
      array[count].store('step_price',step_price)
      count += 1
    end
  end

  def self.calculate_price(array)
    count = 0
    array.each do |a|
      price = (a['charge'].to_f + a['step_price']).floor
      array[count].store('price', price)
      count += 1
    end
  end

  def self.array_sort(array)
    array.sort_by! { |a| a['price'] }
  end
end
