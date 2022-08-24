module Api
  module V1
    class ElectricityPlansController < ApplicationController
      def index
        responce = params[:ampere].to_i + params[:usage].to_i
        electricity_plan = ElectricityPlan.find(1)
        base_rate = electricity_plan.basic_rate.build(ampere: params[:ampere].to_i, price: 1000)
        meter_rate = electricity_plan.meter_rate.build(min_usage: params[:usage].to_i, max_usage: 1000, price: 1000)
        return render json: { status: 'failure', data: base_rate.errors.full_messages } if base_rate.invalid?
        return render json: { status: 'failure', data: meter_rate.errors.full_messages } if meter_rate.invalid?

        # 電力会社でループ回す
        # includesする
        responce = []
        electric_power_companies = ElectricPowerCompany.includes(electricity_plans: :basic_rate).includes(electricity_plans: :meter_rate)
        electric_power_companies.all.each do |company|
          company.electricity_plans.each do |plan|
            basic = plan.basic_rate.find { |basic| basic.ampere == params[:ampere].to_i }
            meter = plan.meter_rate.where(max_usage: nil).find { |meter| meter.min_usage < params[:usage].to_i }
            if meter.present?
              price = basic.price + meter.price * params[:usage].to_i
              responce.push({ provider_name: meter.electricity_plan.electric_power_company.name, plan_name: plan.name, price: price })
            else
              next if basic.blank?
              meter = plan.meter_rate.where.not(max_usage: nil).find{ |meter| meter.min_usage < params[:usage].to_i && meter.max_usage >= params[:usage].to_i }
              price = basic.price + meter.price * params[:usage].to_i
              responce.push({ provider_name: meter.electricity_plan.electric_power_company.name, plan_name: plan.name, price: price })
            end
          end
        end
        render json: { status: 'success', data: responce }
      end

      private
        def index_params
          params.permit(
            :ampere,
            :usage
          )
        end
    end
  end
end
