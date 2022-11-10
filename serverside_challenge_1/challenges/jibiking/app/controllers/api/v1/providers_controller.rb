module Api
  module V1
    class ProvidersController < ApplicationController
      def import
        import_response = Provider.import(params[:file])

        render json: import_response, status: :ok
      end
    end
  end
end
