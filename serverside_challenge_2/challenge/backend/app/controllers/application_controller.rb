# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handle_unexpected_error

  private

  def handle_unexpected_error(exception)
    Rails.logger.error "予期しないエラーが発生しました: #{exception.message}"
    Rails.logger.error exception.backtrace.join('\n')
    render json: { error: '予期しないエラーが発生しました' }, status: :internal_server_error
  end
end
