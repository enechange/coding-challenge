module Api
  class CalculationController < ApplicationController
    def execute
      result, status = CalculationService.execute(params)
      render json: result, status: status
    end
  end
end
