module Api
  module V1
    class ElectricityChargeSimulationController < ApplicationController
      def execute
        res = ElectricityChargeSimulation.new(execute_params).result
        render json: res
      end

      private
        def execute_params
          params.permit(
            :ampere,
            :usage
          )
        end
    end
  end
end
