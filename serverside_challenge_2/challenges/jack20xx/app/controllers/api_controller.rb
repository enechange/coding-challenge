class ApiController < ApplicationController
  before_action :validate_params

  def show_charges
    calculation_service = CalculateChargesService.new(@amps, @watts)
    charges = calculation_service.calculate_charges
    render json: charges
  end

  private

  def validate_params
    @amps = params.require(:amps)
    @watts = params.require(:watts)
    validation_service = ValidateParamsService.new(@amps, @watts)
    errors = validation_service.validate_params

    if errors.any?
      render json: { errors: errors }, status: :bad_request
    end
  rescue ActionController::ParameterMissing => e
    render json: { error: "'#{e.param}'が正しくありません" }, status: :bad_request
  end
end
