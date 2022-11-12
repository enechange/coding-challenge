module Api
  module V1
    class PlansController < ApplicationController
      def import
        import_response = Plan.import(plan_params[:file])

        render json: import_response, status: :ok
      end

      private

      def plan_params
        params.permit(:file)
      end
    end
  end
end
