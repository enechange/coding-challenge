module Api
  class CalculationController < ApplicationController
    def execute
      ampare = params[:ampare]
      basic_fees = BasicFee.getAmpareBasicFees(ampare)
      render json: { data: basic_fees }
    end
  end
end
