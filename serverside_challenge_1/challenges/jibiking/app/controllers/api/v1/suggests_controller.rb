module Api
  module V1
    class SuggestsController < ApplicationController
      include Suggest
    
      def calc
        amp = params[:A]
        kwh = params[:kWh]
    
        calc_response = suggest_calc(amp,kwh)
        
        render json: calc_response, status: :ok
      end
    end
  end
end
