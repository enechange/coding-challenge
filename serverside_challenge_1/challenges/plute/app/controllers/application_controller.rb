class ApplicationController < ActionController::Base

  def render_result(result)
    render json:         result,
           status:       200,
           content_type: 'application/json'
  end

  def render_raw_error(status, error)
    render json:         error,
           status:       status,
           content_type: 'application/problem+json'
  end

  def render_error(error_name)
    render_raw_error(
      I18n.t("api_errors.#{error_name}.status_code"),
      {
        code: I18n.t("api_errors.#{error_name}.code"),
        title: I18n.t("api_errors.#{error_name}.title")
      }
    )
  end
end
