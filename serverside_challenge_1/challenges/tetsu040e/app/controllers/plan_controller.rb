class PlanController < ApplicationController
  before_action :validate_compare_params, only: [:compare]

  def compare
    plan_prices = []
    plans = Plan.eager_load(:basic_prices).where(basic_prices: { ampere: compare_params.ampere }).preload(:unit_prices).all
    plans.each do |plan|
      price = plan.calc_total_price(ampere: compare_params.ampere, amount: compare_params.amount)
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

  def validate_compare_params
    render make_response(nil, 400, compare_params.errors.messages) if compare_params.invalid?
  end

  def compare_params
    @compare_params ||= PlanCompareParam.new(params.permit(:ampere, :amount))
  end
end
