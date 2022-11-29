class ApplicationController < ActionController::API
  rescue_from Exception,                      with: :res_500
  rescue_from ActionController::RoutingError, with: :res_404

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  def res_404(e = nil)
    render make_response(nil, 404, {
      errors: ["page not found"],
    })
  end

  def res_500(e = nil)
    logger.error "error occurred!! with exeption: #{e.message}" if e
    render make_response(nil, 500, {
      errors: ["internal server error"],
    })
  end

  private

  def make_response(data, status = 200, errors = nil)
    {
      status:,
      json: {
        status:,
        data:,
        errors:
      }
    }
  end
end
