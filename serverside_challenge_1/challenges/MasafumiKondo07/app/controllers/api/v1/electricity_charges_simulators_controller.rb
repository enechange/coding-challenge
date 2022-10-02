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
            electricity_fee_instance = plan.electricity_fees.find_by(classification_min: ..params[:amount_used], classification_max: params[:amount_used]..)
            electricity_fee_instance ||= plan.electricity_fees.find_by(classification_min: ..params[:amount_used], classification_max: nil)
            
            simulation_list << {provider_name: company.name, plan_name: plan.name, price: calc_result(basic_charge_instance.price, electricity_fee_instance.calc(params[:amount_used].to_i))}
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

      def calc_result(basic_charge, electricity_fee)
        basic_charge + electricity_fee
      end

      def error_object
        {
          message: "指定されたアンペア数での料金プランは見つかりませんでした。"
        }
      end
    end
  end
end