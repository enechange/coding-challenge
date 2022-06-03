class ApplicationController < ActionController::API
  # 400 Bad Request
  def response_bad_request(error_message)
    render status: 400, json: { status: 400, message: error_message }
  end
end
