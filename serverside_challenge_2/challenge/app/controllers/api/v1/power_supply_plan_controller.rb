# frozen_string_literal: true

module Api
  module V1
    class PowerSupplyPlanController < ApplicationController
      def simulate_all
        simulator = PowerSupplyPlanSimulator.new(params[:amp], params[:meter_rate])
        result = simulator.call

        return render json: [result] if result.is_a?(Hash) && result.key?(:error)

        render json: result
      end
    end
  end
end
