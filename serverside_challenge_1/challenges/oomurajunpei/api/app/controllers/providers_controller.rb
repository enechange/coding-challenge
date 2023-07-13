class ProvidersController < ApplicationController
  def electricity_rate_simulation
    electricity_rate_list = Provider.electricity_rate_list(list_electricity_rate_params)
    render json: electricity_rate_list
  end

  private

  def list_electricity_rate_params
    params.permit(:ampere, :electricity_usage)
  end
end
