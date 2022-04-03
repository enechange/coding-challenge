class ApplicationController < ActionController::API
  def response_success(response_data)
    render json: response_data, status: :ok
  end

  def response_bad_request(message)
    render status: :bad_request, json: { status: 400, message: message }
  end
end
