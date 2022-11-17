module Api
  module V1
    class ElectricityChargeSimulatorsController < ApplicationController
      include ParamsConverter
      include ElectricityChargeSimulatorsCalc
    
      def calc
        # paramsが整数の場合はinteger型に変換
        amp = convert_params(electricity_charge_simulators_params[:A])
        kwh = convert_params(electricity_charge_simulators_params[:kWh])

        # ElectricityChargeSimulatorValidatorモデルのバリデーションに引っかかった場合は400エラーを出す
        amp_and_kwh = ElectricityChargeSimulatorValidator.new(A: amp, kWh: kwh)
        return render status: :bad_request, json: { Error: amp_and_kwh.errors } if amp_and_kwh.invalid?
        
        response = electricity_charge_simulators_calc(amp,kwh)
        
        render json: response, status: :ok
      end

      def electricity_charge_simulators_params
        params.permit(:A, :kWh)
      end
    end
  end
end
