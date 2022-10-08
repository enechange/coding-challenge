module Api
  module V1
    class ElectricityChargesSimulatorsController < ApplicationController
      def index
        companies = Company.all
        simulation_list = []
        companies.each do |company|
          company.plans.each do |plan|
            basic_charge_instance = plan.basic_charges.find_by(ampere: params[:ampere])
            next if basic_charge_instance.nil?

            electricity_fees = plan.electricity_fees.where(classification_min: ..params[:amount_used])
            total_electricity_fee = ElectricityFee.calc(electricity_fees, params[:amount_used].to_i)
            
            simulation_list << {provider_name: company.name, plan_name: plan.name, price: plan.applicable_plan_fee(basic_charge_instance.price, total_electricity_fee)}
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