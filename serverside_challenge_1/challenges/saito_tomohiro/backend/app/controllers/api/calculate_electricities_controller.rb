class Api::CalculateElectricitiesController < ApplicationController
  def simulate
    plans = Plan.all
    prices = plans.map do |plan|
      price = CalculateElectricity.new(plan, params[:ampere], params[:usage])
      price.simulate_electricity_charge
    end
    render json: prices
  end

  private

  def calculate_params
    params.permit(
      :ampere,
      :usage,
    )
  end
end
