module Api
  module V1
    class ElectricityRatesController < ApplicationController
      before_action :validate_params, only: [:execute]

      def execute
        responce = ElectricityRate.new(execute_params).result
        render json: { status: 'success', data: responce }
      end

      private
        def execute_params
          params.permit(
            :ampere,
            :usage
          )
        end

        def validate_params
          electricity_plan = ElectricityPlan.find(1)
          base_rate = electricity_plan.basic_rate.build(ampere: params[:ampere].to_i, price: 1000)
          meter_rate = electricity_plan.meter_rate.build(min_usage: params[:usage].to_i, max_usage: 1000, price: 1000)
          return render json: { status: 'failure', data: base_rate.errors.full_messages } if base_rate.invalid?
          return render json: { status: 'failure', data: meter_rate.errors.full_messages } if meter_rate.invalid?
        end
    end
  end
end
