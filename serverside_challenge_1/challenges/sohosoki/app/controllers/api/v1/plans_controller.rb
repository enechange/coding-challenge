class Api::V1::PlansController < Api::Controller

  def simulate

    ampere = simulate_params[:ampere].to_i
    usage = simulate_params[:usage].to_i

    # 指定のアンペアで利用可能なプラン
    plans = Plan.with_basic_charge(ampere)
    if plans.empty?
      return ok({ message: '指定のアンペア数で利用可能なプランがありません。' }.as_json)
    end

    results = plans.map do |plan|
      {
        provider_name: plan.provider.name,
        plan_name: plan.name,
        price: plan.calculate(ampere, usage)
      }
    end
    ok(results.as_json)
  end

  private

  def simulate_params
    params.permit(:ampere, :usage)
  end

end
