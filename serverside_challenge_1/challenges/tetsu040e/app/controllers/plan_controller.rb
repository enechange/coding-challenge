class PlanController < ApplicationController
  before_action :validate_simurate_params, only: [:simurate]

  def simurate
    plan_prices = []
    plans = Plan.eager_load(:basic_prices).where(basic_prices: { ampere: simurate_params.ampere }).preload(:unit_prices).all
    plans.each do |plan|
      price = plan.calc_total_price(ampere: simurate_params.ampere, amount: simurate_params.amount)
      next if price.nil?

      plan_prices.push({
        plan_name: plan.name,
        provider_name: plan.provider_name,
        price:
      })
    end

    render make_response({ plan_prices: })
  end

  private

  def validate_simurate_params
    render make_response(nil, 400, simurate_params.errors.messages) if simurate_params.invalid?
  end

  def simurate_params
    @simurate_params ||= PlanSimurateParam.new(params.permit(:ampere, :amount))
  end
end
