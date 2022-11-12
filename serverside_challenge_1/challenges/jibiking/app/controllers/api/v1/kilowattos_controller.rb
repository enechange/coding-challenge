module Api
  module V1
    class KilowattosController < ApplicationController
      def import
        import_response = Kilowatto.import(kilowatto_params[:file])

        render json: import_response, status: :ok
      end

      private

      def kilowatto_params
        params.permit(:file)
      end
    end
  end
end
