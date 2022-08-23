module Api
  module V1
    class ElectricityPlansController < ApplicationController
      def index
        responce = params[:ampere].to_i + params[:usage].to_i
        render json: { status: 'success', data: responce }
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
