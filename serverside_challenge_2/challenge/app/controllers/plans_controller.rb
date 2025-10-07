class PlansController < ApplicationController
  PERMITTED_AMPERES = [10, 15, 20, 30, 40, 50, 60].freeze

  def index; end

  # return json : [{ provider_name: ‘Looopでんき’, plan_name: ‘おうちプラン’, price: ‘1234’ }, …]
  def prices
    validate_prices_params

    ampere = params[:ampere].to_i
    usage = params[:usage].to_i
    hash = Plan.plan_prices(ampere:, usage:)
    render json: hash, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  def validate_prices_params
    ampere = params[:ampere]
    usage  = params[:usage]

    unless ampere.present? && usage.present?
      raise ArgumentError, 'Ampere and usage must be provided'
    end

    # 契約アンペア数 : PERMITTED_AMPERES のいずれかとする(単位A)
    unless ampere.match?(/\A\d+\z/) && PERMITTED_AMPERES.include?(ampere.to_i)
      raise ArgumentError, "Ampere must be one of #{PERMITTED_AMPERES.join(', ')}"
    end

    # 使用量 : 0以上の整数(単位kWh)
    unless usage.match?(/\A\d+\z/) && usage.to_i >= 0
      raise ArgumentError, 'Usage must be a non-negative integer'
    end
  end
end
