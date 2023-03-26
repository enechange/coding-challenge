# 電気料金コントローラ
#
# 電気料金に関するアクションを提供するコントローラ
class ElectricityRatesController < ActionController::API
  # 電気料金の計算アクション
  #
  # 電気料金を計算し、結果をJSON形式で返すアクション
  def calculation
    ampere, usage = input_params
    service = ElectricityRatesService.new(ampere, usage)

    rates = service.calculate_rates
    return render_error("入力データに誤りがあります") if rates.empty?

    render status: 200, json: rates
  end

  private

  # 入力パラメータを取得する
  #
  # @return [Array<Integer>] 契約アンペア数と電気使用量を含む配列
  def input_params
    [params[:ampere].to_i, params[:usage].to_i]
  end

  # エラーレスポンスを返す
  #
  # @param [String] message エラーメッセージ
  # @return [void]
  def render_error(message)
    render status: 400, json: { "message": message }
  end
end
