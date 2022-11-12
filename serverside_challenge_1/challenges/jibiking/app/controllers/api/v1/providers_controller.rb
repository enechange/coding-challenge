module Api
  module V1
    class ProvidersController < ApplicationController
      def import
        import_response = Provider.import(provider_params[:file])

        render json: import_response, status: :ok
      end

      private

      def provider_params
        params.permit(:file)
      end
    end
  end
end
