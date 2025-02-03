class Plan < ApplicationRecord
  belongs_to :provider
  has_many :basic_rates
  has_many :usage_rates

  validates :name, presence: true

  def calculate_price(ampere, usage_kwh)
    basic_rate_price = basic_rates.find_by(ampere: ampere)&.price || 0
    return basic_rate_price if basic_rate_price.zero?
    usage_charge = UsageRate.calculate_charge(id, usage_kwh)
    (basic_rate_price + usage_charge).floor
  end

  def self.simulate(ampere, usage_kwh)
    valid_amperes = BasicRate.distinct.pluck(:ampere)
    raise ArgumentError, "指定されたアンペア (#{ampere}A) のプランは存在しません" unless valid_amperes.include?(ampere)

    Plan.includes(:provider, basic_rates: :plan, usage_rates: :plan).map do |plan|
      {
        provider_name: plan.provider.name,
        plan_name: plan.name,
        price: plan.calculate_price(ampere, usage_kwh)
      }
    end
  end

end
