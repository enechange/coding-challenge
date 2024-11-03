class Api::Electricity::CalculateController < ApplicationController
  before_action :price_calculate, only: :create

  def create
    if @prices[:errors].present?
      render json: @prices[:errors], status: :bad_request
    else
      render "electricity/calculate/create", status: :ok
    end
  end

  private

  def create_params
    params.permit(:amperage, :electricity_usage_kwh)
  end

  def price_calculate
    @prices = Plan.calc_prices(create_params[:amperage], create_params[:electricity_usage_kwh])
  end
end
