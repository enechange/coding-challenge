module Api
  module V1
    class ElectricityChargeSimulationController < ApplicationController
      before_action :validate_params, only: :execute

      def execute
        res = ElectricityChargeSimulation.new(execute_params).result
        render status: 200, json: res
      end

      private
        def execute_params
          params.permit(
            :ampere,
            :usage
          )
        end

        def validate_params
          # for ampere
          return respond_bad_request("契約アンペアを入力してください") if params[:ampere].blank?
          return respond_bad_request("契約アンペアは0以上の整数値を入力してください") unless params[:ampere].match(/\A(0|[1-9][0-9]*)\z/)

          # for usage
          return respond_bad_request("使用量を入力してください") if params[:usage].blank?
          return respond_bad_request("使用量は0以上の整数値を入力してください") unless params[:usage].match(/\A(0|[1-9][0-9]*)\z/)
        end
    end
  end
end
