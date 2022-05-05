module Api
  class SimulatedElectricityFeeController < ApplicationController
    before_action :validate_ampere_param, only: :every_plan
    before_action :validate_usage_param, only: :every_plan

    def every_plan
      result = Plan.all.map do |plan|
        ret = ElectricityFee.new(plan: plan, ampere: params[:ampere].to_i, usage: params[:usage].to_i)
        begin
          ret.calclate
          {
            provider_name: ret.plan.provider.name,
            plan_name: ret.plan.name,
            price: ret.fee
          }
        rescue ElectricityFee::UnsuppliedAmpereException
          nil
        end
      end

      render_result(result.compact)
    end

    private

    def validate_ampere_param
      return render_error('unspecified_ampere') if params[:ampere].blank?
      return render_error('ampere_must_be_integer') unless params[:ampere].match(/\A(0|[1-9][0-9]*)\z/)
      return render_error('unacceptable_ampere') unless ElectricityFee::AMPERE.include?(params[:ampere].to_i)
    end

    def validate_usage_param
      return render_error('unspecified_usage') if params[:usage].blank?
      return render_error('usage_must_be_integer') unless params[:usage].match(/\A(0|[1-9][0-9]*)\z/)
      return render_error('usages_out_of_range') if params[:usage].to_i > ElectricityFee::MAX_USAGE
    end
  end
end