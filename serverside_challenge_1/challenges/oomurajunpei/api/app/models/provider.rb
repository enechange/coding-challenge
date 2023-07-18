class Provider < ApplicationRecord
  has_many :basic_rates, dependent: :destroy
  has_many :pay_per_use_rates, dependent: :destroy

  validates :name, presence: true
  validates :plan_name, presence: true

  def self.electricity_rate_list(params)
    electricity_rate_list = []
    Provider.all.each do |provider|
      basic_rate = provider.basic_rates.find_by(ampere: params[:ampere].to_i)
      next if basic_rate.nil?
      pay_per_use_rate = provider.pay_per_use_rates.find_by(
        min_electricity_usage: [nil, ..params[:electricity_usage].to_i],
        max_electricity_usage: [nil, params[:electricity_usage].to_i..]
      )
      total_price = basic_rate.price + pay_per_use_rate.unit_price * params[:electricity_usage].to_i
      electricity_rate_list << {
        provider_name: provider.name,
        plan_name: provider.plan_name,
        price: total_price.floor
      }
    end
    return electricity_rate_list
  end
end
