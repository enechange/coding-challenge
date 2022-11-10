module Api
  module V1
    class PlansController < ApplicationController
      def import
        import_response = Plan.import(params[:file])

        render json: import_response, status: :ok
      end
    end
  end
end
