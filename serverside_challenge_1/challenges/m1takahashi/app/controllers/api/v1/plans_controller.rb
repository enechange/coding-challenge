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
      unit_price = commodity_unit_price(commodity_charges, @amount)
      # 従量料金② 使用量 * 単価
      commodity_price = unit_price * @amount
      # 合計金額
      price = basic_price + commodity_price
      plans.push({
        provider_name: provider.provider_name,
        plan_name: provider.plan_name,
        price: price.ceil # 小数点以下切り上げ
      })
    end
    render :json => { 'code' => API_CODE_SUCCESS, 'message' => "", 'data' => plans }
  end
  
  private
  
  def validate_params
    message = ""
    # 契約アンペア数確認    
    @ampere = params[:ampere].to_i
    unless BasicCharge::AMPERES.include?(@ampere)
      message = t("api.errors.ampere")
    end
    # 使用量確認
    if params[:amount].blank?
      message = t("api.errors.amount_blank")
    end
    @amount = params[:amount].to_i
    unless CommodityCharge::AMOUNT_MIN <= @amount && CommodityCharge::AMOUNT_MAX >= @amount
      message = t("api.errors.amount_range")
    end
    unless message.empty?
      render :json => { 'code' => API_CODE_ERROR, 'message' => message, 'data' => [] } and return
    end
  end
end
