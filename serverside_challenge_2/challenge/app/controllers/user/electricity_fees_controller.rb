# frozen_string_literal: true

module User
  class ElectricityFeesController < ApplicationController
    def index
      contract_ampere = params[:contract_ampere].to_i
      usage_kwh = params[:usage_kwh].to_i

      if contract_ampere <= 0 || usage_kwh.negative?
        render json: { error: 'Invalid input' }, status: :bad_request
        return
      end

      results = ElectricityFeeCalculatorService.calculate_fees(contract_ampere, usage_kwh)
      render json: results
    end
  end
end
