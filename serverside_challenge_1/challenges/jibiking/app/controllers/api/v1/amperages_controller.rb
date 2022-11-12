module Api
  module V1
    class AmperagesController < ApplicationController
      def import
        import_response = Amperage.import(amperage_params[:file])

        render json: import_response, status: :ok
      end

      private

      def amperage_params
        params.permit(:file)
      end
    end
  end
end
