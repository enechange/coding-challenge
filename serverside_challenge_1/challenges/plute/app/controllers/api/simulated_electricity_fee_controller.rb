module Api
  class SimulatedElectricityFeeController < ApplicationController
    before_action :validate_ampere_param, only: :every_plan
    before_action :validate_usage_param, only: :every_plan

    def every_plan
      result = Plan.all.map do |plan|
        let = ElectricityFee.new(plan: plan, ampere: params[:ampere].to_i, usage: params[:usage].to_i)
        let.calclate
        {
          provider_name: let.plan.provider.name,
          plan_name: let.plan.name,
          price: let.fee
        }
      end

      render_result(result)
    end

    private

    def validate_ampere_param
      return render_error({ status_code: 400, title: 'アンペアが指定されていません' }) if params[:ampere].blank?
      return render_error({ status_code: 400, title: '指定された値が整数ではありません。アンペアは10, 15, 20, 30, 40, 50, 60のいずれかの整数で指定してください'}) unless params[:ampere].match(/\A(0|[1-9][0-9]*)\z/)
      return render_error({ status_code: 400, title: 'アンペアは10, 15, 20, 30, 40, 50, 60のいずれかの整数で指定してください'}) unless ElectricityFee::AMPERE.include?(params[:ampere].to_i)
    end

    def validate_usage_param
      return render_error({ status_code: 400, title: '使用量が指定されていません' }) if params[:usage].blank?
      return render_error({ status_code: 400, title: '指定された値が整数ではありません。使用量は0以上99,999以下の整数で指定してください' }) unless params[:usage].match(/\A(0|[1-9][0-9]*)\z/)
      return render_error({ status_code: 400, title: '使用量は0以上99,999以下の整数で指定してください' }) if params[:usage].to_i > 99999
    end
  end
end