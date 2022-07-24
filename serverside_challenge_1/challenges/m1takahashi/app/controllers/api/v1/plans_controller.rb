class Api::V1::PlansController < ApplicationController
  include Common
  include CommodityChargeUtil

  before_action :validate_params, only: [:index] 

  def index
    providers = Provider.all
    plans = []
    providers.each do |provider|
      price = 0
      basic_charge = BasicCharge.where(provider_id: provider.id).where(ampere: @ampere).first
      # 東京ガス,JXTGでんきは,10A,15A,20Aに該当するプランがないのでスキップ
      unless basic_charge
        next
      end
      # 基本料金①
      basic_price = basic_charge.charge_with_tax
      # 従量課金単価を取得
      commodity_charges = CommodityCharge.provider(provider.id).all
      unit_price = commodity_unit_price(commodity_charges, @amount_of_use)
      # 従量料金② 使用量 * 単価
      commodity_price = unit_price * @amount_of_use
      # 合計金額
      price = basic_price + commodity_price
      plans.push({
        provider_name: provider.provider_name,
        plan_name: provider.plan_name,
        price: price.ceil # 小数点以下切り上げ
      })
    end
    result = {
      'code' => API_CODE_SUCCESS,
      'message' => "",
      'data' => plans
    }
    render :json => result
  end
  
  private
  
  def validate_params
    message = ""
    # アンペア数確認    
    @ampere = params[:ampere].to_i
    unless BasicCharge::AMPERES.include?(@ampere)
      message = t("api.errors.ampere")
    end
    # 使用量確認
    @amount_of_use = params[:amount_of_use].to_i
    unless CommodityCharge::AMOUNT_OF_USE_MIN <= @amount_of_use && CommodityCharge::AMOUNT_OF_USE_MAX >= @amount_of_use
      message = t("api.errors.amount_of_use")
    end
    unless message.empty?
      render :json => { 'code' => API_CODE_ERROR, 'message' => message, 'data' => [] } and return
    end
  end
end
