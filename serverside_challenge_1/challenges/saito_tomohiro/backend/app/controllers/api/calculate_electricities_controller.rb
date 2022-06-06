module Api
  class CalculateElectricitiesController < ApplicationController
    before_action :validate_params_ampere, only: [:simulate]
    before_action :validate_params_usage, only: [:simulate]

    def simulate
      plans = Plan.all
      prices = plans.map do |plan|
        price = CalculateElectricity.new(plan, simulate_params[:ampere],
                                         simulate_params[:usage]).simulate_electricity_charge
        { price: price, plan_name: plan.name, provider_name: plan.provider.name }
      end
      render json: prices
    end

    private

    def simulate_params
      params.permit(
        :ampere,
        :usage
      )
    end

    def validate_params_ampere
      return response_bad_request('アンペア数を指定してください') if params[:ampere].blank?
    end

    def validate_params_usage
      return response_bad_request('使用量を指定してください') if params[:usage].blank?
      return response_bad_request('使用量は0以上の数字で指定してください') if params[:usage].match(/[^0-9,^０-９]/)
    end
  end
end
