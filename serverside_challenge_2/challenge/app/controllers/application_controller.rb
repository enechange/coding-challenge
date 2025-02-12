class ApplicationController < ActionController::API
  rescue_from StandardError, with: :internal_server_error
  rescue_from ActionController::RoutingError, with: :not_found

  def raise_not_found
    raise ActionController::RoutingError, "No route matches #{params[:unmatched_route]}"
  end

  protected

  def not_found
    respond_with_error(404)
  end

  def internal_server_error(e)
    logger.error(e)
    respond_with_error(500)
  end

  private

  def respond_with_error(code)
    render json: { error: Rack::Utils::HTTP_STATUS_CODES[code] }, status: code
  end
end
