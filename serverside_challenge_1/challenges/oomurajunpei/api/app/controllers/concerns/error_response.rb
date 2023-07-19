module ErrorResponse
  extend ActiveSupport::Concern

  def render_bad_request(title)
    render json: { title: }, status: :bad_request
  end

  def render_not_found(title)
    render json: { title: }, status: :not_found
  end
end
