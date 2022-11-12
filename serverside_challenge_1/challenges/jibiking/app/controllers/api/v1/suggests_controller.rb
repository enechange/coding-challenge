module Api
  module V1
    class SuggestsController < ApplicationController
      include Suggest
    
      def calc
        amp = suggest_params[:A]
        kwh = suggest_params[:kWh]
        
        calc_response = suggest_calc(amp,kwh)
        
        render json: calc_response, status: :ok
      end

      def suggest_params
        params.permit(:A, :kWh)
      end
    end
  end
end
