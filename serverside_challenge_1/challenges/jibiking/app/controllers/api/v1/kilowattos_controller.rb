module Api
  module V1
    class KilowattosController < ApplicationController
      def import
        return render status: :bad_request, json: { Erorr: 'インポートが失敗しました。CSVファイルを指定してください。' } if kilowatto_params[:file].blank?
        import_response = Kilowatto.import(kilowatto_params[:file])

        # CSVインポート後のレスポンス
        if import_response == false
          render status: :bad_request, json: { Erorr: 'インポートが失敗しました。CSVファイルのデータ形式を見直してください。' }
        else
          render status: :ok, json: { Success: 'インポートが成功しました。' }
        end
      end

      private

      def kilowatto_params
        params.permit(:file)
      end
    end
  end
end
