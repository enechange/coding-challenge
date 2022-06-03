class Api::CalculateElectricitiesController < ApplicationController
  def simulate
    plans = Plan.all
    prices = plans.map do |plan|
      price = CalculateElectricity.new(plan, params[:ampere], params[:usage]).simulate_electricity_charge
      { price: price, plan: plan.name, provider: plan.provider.name }
    end
    render json: prices
  end

  private

  def calculate_params
    params.require(
      :ampere,
      :usage
    )
  end
end
