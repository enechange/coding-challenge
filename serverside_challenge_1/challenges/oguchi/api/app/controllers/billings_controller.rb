class BillingsController < ApplicationController
  def calculate
    results = BillingPlan.all
      .map do |p|
        {
          provider_name: p.provider_name,
          plan_name: p.plan_name,
          price: p.calculate(params[:amperage].to_i, params[:used_kwh].to_i),
        }
        rescue BillingPlan::NoCategoryError => e
          # 取り扱いがないプランはスキップ
        end
        .filter { |r| r.present? }

    render json: results
  end
end
