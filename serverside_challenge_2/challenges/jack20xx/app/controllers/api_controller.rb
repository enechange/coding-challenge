class ApiController < ApplicationController
  before_action :set_params, :validate_params

  def show_charges
    calculation_service = CalculateChargesService.new(@amps, @watts)
    charges = calculation_service.calculate_charges
    render json: charges
  end

  private

  def set_params
    @amps = params[:amps]
    @watts = params[:watts]
  end

  def validate_params
    validation_service = ValidateParamsService.new(params)
    errors = validation_service.validate_params

    if errors.any?
      render json: { errors: errors }, status: :bad_request
    end
  end
end
