class ElectricityRatePlansController < ApplicationController
  include NumericConverter

  def index
    contract_amperage = convert_integer(electron_info_params[:contract_amperage])
    electricity_usage = convert_integer(electron_info_params[:electricity_usage])

    user_electron_info = ElectronInfoValidator.new(
      contract_amperage: contract_amperage,
      electricity_usage: electricity_usage
    )
    unless user_electron_info.valid?
      return render status: 400, json: { errors: user_electron_info.errors }
    end

    response = []
    ElectricityRatePlan.preload(:basic_charges, :usage_charges).find_each do |plan|
      # 電気料金を取得
      price = ElectricityRateCalculation.calculation_electricity_charge(plan, user_electron_info)
      if price.blank?
        next
      end

      response.push({
          provider_name: plan.electric_power_provider.name,
          plan_name: plan.name,
          price: price
        })
    end

    render json: response
  end

  private
  def electron_info_params
    params.permit(:contract_amperage, :electricity_usage)
  end
end
