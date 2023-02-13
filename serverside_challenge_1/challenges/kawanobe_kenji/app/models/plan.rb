class Plan < ApplicationRecord
  belongs_to :provider
  has_many :basic_charges, dependent: :destroy
  has_many :commodity_charges, dependent: :destroy

  validates :provider_id, presence: true
  validates :name, presence: true

  def basic_charge_by(ampere)
    target_basic_charge = basic_charges.find do |basic_charge|
      basic_charge.ampere == ampere
    end
    basic_charge = target_basic_charge && target_basic_charge.charge
  end

  def commodity_charge_by(kwh)
    total_commodity_charge = 0
    diff_kwh = 0
    commodity_charges.sort_by(&:kwh_from).each do |commodity_charge|
      min_kwh = commodity_charge.kwh_from || 0
      max_kwh = commodity_charge.kwh_to || 99999999
      charge = commodity_charge.charge

      if min_kwh >= kwh
        next
      elsif max_kwh >= kwh && kwh > min_kwh
        diff_kwh = kwh - min_kwh
      elsif kwh > max_kwh
        diff_kwh = max_kwh.blank? ? kwh - min_kwh : max_kwh - min_kwh
      else
        next
      end

      total_commodity_charge += charge * diff_kwh
    end
    total_commodity_charge
  end
end
