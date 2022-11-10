module Api
  module V1
    class AmperagesController < ApplicationController
      def import
        import_response = Amperage.import(params[:file])

        render json: import_response, status: :ok
      end
    end
  end
end
