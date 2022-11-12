module Api
  module V1
    class ElectricityChargeSimulatorsController < ApplicationController
      include ElectricityChargeSimulatorsCalc
    
      def calc
        amp = electricity_charge_simulators_params[:A]
        kwh = electricity_charge_simulators_params[:kWh]
        
        calc_response = electricity_charge_simulators_calc(amp,kwh)
        
        render json: calc_response, status: :ok
      end

      def electricity_charge_simulators_params
        params.permit(:A, :kWh)
      end
    end
  end
end
