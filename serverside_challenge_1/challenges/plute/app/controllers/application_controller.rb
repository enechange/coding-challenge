class ApplicationController < ActionController::Base

  def render_result(result)
    render json:         result,
           status:       200,
           content_type: 'application/json'
  end

  def render_error(error)
    render json:         error,
           status:       error[:status_code],
           content_type: 'application/problem+json'
  end
end
