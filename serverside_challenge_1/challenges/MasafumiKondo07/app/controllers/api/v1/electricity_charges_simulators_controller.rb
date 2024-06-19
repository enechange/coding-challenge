module Api
  module V1
    class ElectricityChargesSimulatorsController < ApplicationController
      def index
        simulation_list = []
        Company.preload(:plans).all.each do |company|
          company.plans.each do |plan|
            basic_charge_instance = plan.basic_charges.find_by(ampere: params[:ampere])
            next if basic_charge_instance.nil?

            # 従量料金の計算
            total_electricity_fee = ElectricityFee.calc(plan, params[:amount_used].to_i)
            
            simulation_list << {company_name: company.name, plan_name: plan.name, price: plan.applicable_plan_fee(basic_charge_instance.price, total_electricity_fee)}
          end
        end
        # 指定された基本料金でのプランが見つからない場合、エラーメッセージを返却
        if (simulation_list.blank?)
          render json: error_object
          return
        end
        render json: simulation_list
      end

      private
      def error_object
        {
          message: "指定されたアンペア数での料金プランは見つかりませんでした。"
        }
      end
    end
  end
end