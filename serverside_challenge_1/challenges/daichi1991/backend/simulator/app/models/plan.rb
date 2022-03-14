class Plan < ApplicationRecord
  has_many :basic_charges, dependent: :destroy
  has_many :commodity_charges, dependent: :destroy

  validates :provider_name, presence: true
  validates :plan, presence: true

  scope :select_plan, lambda {
                        select('plans.id,
                          plans.provider_name,
                          plans.plan,
                          basic_charges.charge,
                          commodity_charges.unit_price')
                      }
  scope :basic_charges, -> { joins(:basic_charges) }
  scope :commodity_charges, -> { joins(:commodity_charges) }

  scope :join_tables, -> { select_plan.basic_charges.commodity_charges }

  scope :ampere, ->(get_ampere) { where(basic_charges: { ampere: get_ampere }) }
  scope :min_amount, ->(get_kwh) { where('min_amount <= ?', get_kwh) }
  scope :max_amount, ->(get_kwh) { where('max_amount >= ?', get_kwh) }

  def self.get_data(get_ampere, get_kwh)
    records = join_tables.ampere(get_ampere).min_amount(get_kwh).max_amount(get_kwh)
    records = record_to_hash(records)
    records = store_unit(records, get_kwh)
    records = calculate_price(records)
    records = delete_key(records)
    array_sort(records)
  end

  def self.record_to_hash(records)
    records.map(&:attributes)
  end

  def self.store_unit(array, kwh)
    count = 0
    array.each do |_a|
      array[count].store('unit', kwh.to_i)
      count += 1
    end
  end

  def self.calculate_price(array)
    count = 0
    array.each do |a|
      price = a['charge'].to_f + a['unit'] * a['unit_price'].to_f
      array[count].store('price', price)
      count += 1
    end
  end

  def self.delete_key(array)
    array.each do |a|
      a.delete_if{|k,v|
        k != 'provider_name' && k != 'plan' && k != 'price'
      }
    end
  end

  def self.array_sort(array)
    array.sort_by! { |a| a['price'] }
  end
end
