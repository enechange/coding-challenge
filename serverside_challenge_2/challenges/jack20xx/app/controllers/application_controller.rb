class ApplicationController < ActionController::API
  def not_found
    render json: { error: 'URLが間違っています' }, status: :not_found
  end
end
