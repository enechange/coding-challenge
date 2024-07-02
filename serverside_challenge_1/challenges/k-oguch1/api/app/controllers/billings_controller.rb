class BillingsController < ApplicationController
  def calculate
    render json: calculated_results
  end

  private

  def calculated_results
    BillingPlan.all
     .map do |p|
      {
        provider_name: p.provider_name,
        plan_name: p.plan_name,
        price: p.calculate(params[:amperage].to_i, params[:used_kwh].to_i)
      }
      rescue BillingPlan::NoCategoryError
      # 取り扱いがないプランはスキップ
    end
       .filter(&:present?)
  end
end
