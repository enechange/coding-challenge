module Api
  module V1
    class KilowattosController < ApplicationController
      def import
        import_response = Kilowatto.import(params[:file])

        render json: import_response, status: :ok
      end
    end
  end
end
