# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ApplicationError::BadRequestError, with: :bad_request_error

  def bad_request_error(exception)
    render json: { message: exception.message }, status: :bad_request
  end
end
