
class SimulationsController < ApplicationController
  def calculate
    ampere = params[:ampere].to_i
    usage_kwh = params[:usage].to_i
    unless BasicRate::VALID_AMPERES.include?(ampere) && usage_kwh >= UsageRate::MIN_USAGE_KWH
      return render json: { error: 'リクエストが不正です' }, status: :bad_request
    end

    result = Plan.simulate(ampere, usage_kwh)
    render json: result
  end
end
