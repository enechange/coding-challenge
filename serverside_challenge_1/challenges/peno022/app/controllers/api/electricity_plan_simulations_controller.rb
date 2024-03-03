# frozen_string_literal: true

module Api
  class ElectricityPlanSimulationsController < ApplicationController
    def index
      electricity_plans = BuildElectricityPlansService.new.call(::PLANS)
      simulator = ElectricityPlansSimulator.new(
        plans: electricity_plans,
        consumption: params[:consumption],
        contract_amperage: params[:contract_amperage]
      )
      errors = simulator.validate_params
      unless errors.empty?
        render json: { errors: }, status: :bad_request
        return
      end
      response = simulator.calculate_results
      render json: response, status: :ok
    end
  end
end
