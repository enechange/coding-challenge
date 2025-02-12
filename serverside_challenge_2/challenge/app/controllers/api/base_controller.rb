# frozen_string_literal: true

class Api::BaseController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: "Record not found" }, status: 404
  end

  rescue_from ActionController::ParameterMissing, App::InvalidParameterError do |e|
    render json: { error: e.to_s }, status: 400
  end

  private

  def respond_with_error(code)
    render json: { error: Rack::Utils::HTTP_STATUS_CODES[code] }, status: code
  end
end
