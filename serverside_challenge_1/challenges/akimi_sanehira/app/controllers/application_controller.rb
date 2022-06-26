class ApplicationController < ActionController::Base
  def respond_bad_request(error_message)
    json_content = {
      status: 400,
      message: error_message
    }
    render status: 400, json: json_content
  end
end
