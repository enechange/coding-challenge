# frozen_string_literal: true

class ApplicationController < ActionController::API
  def route_not_found
    render status: :not_found, json: {
      status: 'error',
      message: 'リクエストされたエンドポイントが見つかりません。',
      data: {}
    }
  end
end
