class Api::V1::EnergyPricesController < ApplicationController
  before_action :valid_params

  def index
    energy_prices = Utils::EnergyPrice.each_prices(csv_data, prices_params[:compared_amperes], prices_params[:consumption])
    render status: :ok, json: { energy_prices: energy_prices }
  rescue => e
    render status: :unprocessable_entity, json: { error_message: 'データを取得できませんでした。' }
  end

  private

  def csv_data
    Utils::EnergyPrice.load_csv
  end

  def prices_params
    p = params.permit(:compared_amperes, :consumption)
    p[:compared_amperes] = p[:compared_amperes].to_i
    p[:consumption] = p[:consumption].to_i
    p
  end

  def valid_params
    if Utils::EnergyPrice::CONTRACT_ANPERES.exclude?(prices_params[:compared_amperes])
      render_unprocessable_entity('正しい契約アンペア数を入力してください。')
    end

    if prices_params[:consumption].negative?
      render_unprocessable_entity('正しい使用量を入力してください。')
    end
  end

  def render_unprocessable_entity(message = '正しい値を入力してください。')
    render json: { error_message: message }, status: :unprocessable_entity
  end
end
