module Api
  class ElectricityRateSimulationsController < ApplicationController
    def index
      return bad_request_error if electricity_rate_simulation_params[:amperage].blank? || electricity_rate_simulation_params[:usage_kwh].blank?

      render json: [
        {
          provider_name: 'Provider A',
          plan_name: 'Plan A',
          price: 1000
        }
      ]
    end

    private

    def electricity_rate_simulation_params
      params.permit(:amperage, :usage_kwh)
    end

    def bad_request_error
      render json: { error: 'Bad Request' }, status: :bad_request
    end
  end
end