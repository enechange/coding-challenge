class ApplicationController < ActionController::API


def response_success(response_data)
  render json: response_data, status: 200
end

def response_bad_request
  render status: 400, json: { status: 400, message: 'Bad Request' }
end
end
