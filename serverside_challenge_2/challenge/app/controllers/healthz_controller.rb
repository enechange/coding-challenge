# frozen_string_literal: true

class HealthzController < ApplicationController
  def show
    ActiveRecord::Base.connection.execute('SELECT 1')
    render json: { status: 'ok' }, status: :ok
  rescue StandardError => e
    # Healthz は「アプリ全体の健全性」を 200/503 で表現するエンドポイント。
    # 想定外例外も含めて広く捕捉し、503 として ALB に伝える。
    Rails.logger.error("Healthz check failed: #{e.class}: #{e.message}")
    render json: { status: 'error' }, status: :service_unavailable
  end
end
