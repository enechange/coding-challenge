class BillingsController < ApplicationController
  before_action :validate_calculate_params, only: :calculate

  def calculate
    results = BillingPlan.all
      .map do |p|
        {
          provider_name: p.provider_name,
          plan_name: p.plan_name,
          price: p.calculate(calculate_params[:amperage], calculate_params[:used_kwh]),
        }
        rescue BillingPlan::NoCategoryError => e
          # 取り扱いがないプランはスキップ
        end
        .filter { |r| r.present? }

    render json: results
  end

  private

  def validate_calculate_params
    return render json: { error: 'Invalid amperage' }, status: :bad_request \
      unless calculate_params[:amperage].is_a? Numeric
    return render json: { error: 'Invalid used_kwh' }, status: :bad_request \
      unless calculate_params[:used_kwh].is_a? Numeric

    return render json: { error: 'Invalid amperage' }, status: :bad_request \
      unless BillingPlan::VALID_AMPERAGES.include?(calculate_params[:amperage])
  end

  def calculate_params
    {
      amperage: params.require(:amperage),
      used_kwh: params.require(:used_kwh),
    }
  end
end
