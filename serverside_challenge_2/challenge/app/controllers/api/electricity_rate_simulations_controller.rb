# frozen_string_literal: true

module Api
  class ElectricityRateSimulationsController < ApplicationController
    def index
      params = electricity_rate_simulation_params
      electricity_rate_simulation = ElectricityRateSimulation.new(params['amperage'], params['usage_kwh'])

      raise ActiveModel::ValidationError, electricity_rate_simulation if electricity_rate_simulation.invalid?

      simulation_result = electricity_rate_simulation.execute

      render json: simulation_result
    end

    private

    def electricity_rate_simulation_params
      params.require(%i[amperage usage_kwh])
      params.permit(:amperage, :usage_kwh)
    end
  end
end
