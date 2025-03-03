class ElectricityCharges::CalculateController < ApplicationController
  include ElectricChargesHelper
  def calc
    error, status = validate_params(params)
    if error
      return render json: error, status: status
    end

    calc_result, calc_status = import_price_from_yaml(params[:ampere].to_i, params[:usage].to_i)

    render json: calc_result, status: calc_status
  end
end
