module Api
  module V1
    class PlansController < ApplicationController
      def import
        return render status: :bad_request, json: { Erorr: 'インポートが失敗しました。CSVファイルを指定してください。' } if plan_params[:file].blank?
        import_response = Plan.import(plan_params[:file])

        # CSVインポート後のレスポンス
        if import_response == false
          render status: :bad_request, json: { Erorr: 'インポートが失敗しました。CSVファイルのデータ形式を見直してください。' }
        else
          render status: :ok, json: { Success: 'インポートが成功しました。' }
        end
      end

      private

      def plan_params
        params.permit(:file)
      end
    end
  end
end
