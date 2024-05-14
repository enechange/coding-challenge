# frozen_string_literal: true

module Api
  class ElectricityRateSimulationsController < ApplicationController
    def index
      electricity_rate_simulation = ElectricityRateSimulation.new(electricity_rate_simulation_params['amperage'], electricity_rate_simulation_params['usage_kwh'])

      raise ActiveModel::ValidationError, electricity_rate_simulation if electricity_rate_simulation.invalid?

      simulation_result = electricity_rate_simulation.execute(electricity_rate_simulation_params)

      render json: simulation_result
    end

    private

    def electricity_rate_simulation_params
      params.require(%i[amperage usage_kwh])
      params.permit(:amperage, :usage_kwh)
    end
  end
end
