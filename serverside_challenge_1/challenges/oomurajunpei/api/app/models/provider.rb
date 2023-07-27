class Provider < ApplicationRecord
  has_many :plans, dependent: :destroy

  validates :name, presence: true

  def self.electricity_rate_list(params)
    electricity_rate_list = []
    Provider.all.each do |provider|
      provider.plans.each do |plan|
        basic_rate = plan.basic_rates.find_by(ampere: params[:ampere].to_i)
        next if basic_rate.nil?
        pay_per_use_rate = plan.pay_per_use_rates.find_by(
          min_electricity_usage: [nil, ..params[:electricity_usage].to_i],
          max_electricity_usage: [nil, params[:electricity_usage].to_i..]
        )
        total_price = basic_rate.price + pay_per_use_rate.unit_price * params[:electricity_usage].to_i
        electricity_rate_list << {
          provider_name: provider.name,
          plan_name: plan.name,
          price: total_price.floor
        }
      end
    end
    return electricity_rate_list
  end
end
