# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveModel::ValidationError, with: :validation_error

  private

  def parameter_missing(error)
    render json: { error: error.message }, status: :bad_request
  end

  def validation_error(error)
    render json: { error: error.model.errors.full_messages }, status: :unprocessable_entity
  end
end
