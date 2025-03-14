# frozen_string_literal: true

class ElectricityPricesController < ApplicationController
  ALLOWED_AMPERES = [10, 15, 20, 30, 40, 50, 60].freeze

  def index
    ampere = Integer(index_params[:ampere])
    usage = Integer(index_params[:usage])

    unless ALLOWED_AMPERES.include?(ampere)
      render json: { error: "アンペア数(ampere)は #{ALLOWED_AMPERES.join('/')} のいずれかを指定してください" }, status: :bad_request
      return
    end

    if usage.negative?
      render json: { error: '使用量(usage)は 0 以上の整数を指定してください' }, status: :bad_request
      return
    end

    plans = ElectricityPriceCalculateService.new(ampere, usage).calc
    render json: plans
  rescue TypeError
    render json: { error: 'アンペア数(ampere)と使用量(usage)の両方が指定されていません' }, status: :bad_request
  rescue ArgumentError
    render json: { error: 'アンペア数(ampere)と使用量(usage)を整数で指定してください' }, status: :bad_request
  end

  private

  def index_params
    params.permit(:ampere, :usage)
  end
end
