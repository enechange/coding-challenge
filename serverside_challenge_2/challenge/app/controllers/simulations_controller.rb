
class SimulationsController < ApplicationController
  def calculate
    ampere = params[:ampere].to_i
    usage_kwh = params[:usage].to_i
    unless BasicRate::VALID_AMPERES.include?(ampere) && usage_kwh >= UsageRate::MIN_USAGE_KWH
      return render json: { error: 'リクエストが不正です' }, status: :bad_request
    end

    begin
      result = Plan.simulate(ampere, usage_kwh)
      render json: result
    rescue ArgumentError => e
      render json: { error: e.message }, status: :bad_request
    end
  end
end
