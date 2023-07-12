class ProvidersController < ApplicationController
  def electricity_rate_simulation
    electricity_rate_list = []
    Provider.all.each do |provider|
      basic_rate = provider.basic_rates.find_by(ampere: list_electricity_rate_params[:ampere].to_i)
      next if basic_rate.nil?
      pay_per_use_rate = provider.pay_per_use_rates.find_by(
        min_electricity_usage: [nil, ..list_electricity_rate_params[:electricity_usage].to_i],
        max_electricity_usage: [nil, list_electricity_rate_params[:electricity_usage].to_i..]
      )
      total_price = basic_rate.price + pay_per_use_rate.unit_price * list_electricity_rate_params[:electricity_usage].to_i
      electricity_rate_list << { provider_name: provider.name, plan_name: provider.plan_name, price: total_price.round(2)}
    end
    render json: electricity_rate_list
  end

  private

  def list_electricity_rate_params
    params.permit(:ampere, :electricity_usage)
  end
end
