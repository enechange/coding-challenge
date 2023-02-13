module Api
  module V1
    class PlansController < ApplicationController
      def index
        ampere = plan_params[:ampere]
        kwh = plan_params[:kwh]
        errors = []

        # 入力チェック
        if ampere.to_s !~ /10|15|20|30|40|50|60/
          errors.push("契約アンペア数は[10 / 15 / 20 / 30 / 40 / 50 / 60]のいずれかの値を入力してください")
        end
        errors.push("使用量は0以上の整数を入力してください") if kwh.to_s !~ /^[1-9][0-9]+$/
        return render json: { errors: }, status: 400 unless errors.empty?

        # シミュレーション結果の取得
        response = []
        Plan.preload(:basic_charges).find_each do |plan|
          # 1. 基本料金を計算
          basic_charge = plan.basic_charge_by(ampere.to_i)
          # NOTE: ここでnextを実行することによって、該当する契約容量を持たないプランはレスポンス候補から外れる
          next if basic_charge.blank?

          # 2. 従量料金を計算
          total_commodity_charge = plan.commodity_charge_by(kwh.to_i)

          # 3. レスポンスのオブジェクトを生成
          simulation_result = {
            provider_name: plan.provider.name,
            plan_name: plan.name,
            price: (basic_charge + total_commodity_charge).floor
          }
          response.push(simulation_result)
        end

        render json: response, status: 200
      end

      private

      def plan_params
        params.permit(:ampere, :kwh)
      end
    end
  end
end
