class ApplicationController < ActionController::API
  def not_found
    render json: { error: I18n.t('errors.invalid_url') }, status: :not_found
  end
end
