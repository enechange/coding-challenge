# frozen_string_literal: true

class Api::V1::ElectricityCharges::SimulateController < Api::BaseController
  def index
    binding.irb
    form    = Form::Simulate.new(simulate_params)
    binding.irb
    results = FetchElectricityChargeService.new(form).call

    render json: { results: results }, status: 200
  end

  private

  def simulate_params
    params.permit(:ampere, :usage)
  end
end
