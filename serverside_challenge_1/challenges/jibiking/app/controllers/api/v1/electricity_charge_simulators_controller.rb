module Api
  module V1
    class ElectricityChargeSimulatorsController < ApplicationController
      include ElectricityChargeSimulatorsCalc
    
      def calc
        amp = electricity_charge_simulators_params[:A].to_i
        kwh = electricity_charge_simulators_params[:kWh].to_i

        # ElectricityChargeSimulatorValidatorモデルのバリデーションに引っかかった場合は400エラーを出す
        amp_and_kwh = ElectricityChargeSimulatorValidator.new(A: amp, kWh: kwh)
        unless amp_and_kwh.valid?
          return render status: :bad_request, json: { Error: amp_and_kwh.errors }
        end
        
        response = electricity_charge_simulators_calc(amp,kwh)
        
        render json: response, status: :ok
      end

      def electricity_charge_simulators_params
        params.permit(:A, :kWh)
      end
    end
  end
end
