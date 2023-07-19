class ProvidersController < ApplicationController
  def electricity_rate_simulation
    if electricity_rate_params_blank?
      render_bad_request('必要な値がありません')
    elsif ampere_invalid?
      render_bad_request('契約アンペア数は10 / 15 / 20 / 30 / 40 / 50 / 60 のいずれかから選択してください')
    elsif electricity_rate_params[:electricity_usage].to_i.negative?
      render_bad_request('電力使用量は0以上の整数でご入力ください')
    else
      electricity_rate_list = Provider.electricity_rate_list(electricity_rate_params)
      render json: electricity_rate_list
    end
  end

  private

  def electricity_rate_params
    params.permit(:ampere, :electricity_usage)
  end

  def electricity_rate_params_blank?
    electricity_rate_params[:ampere].blank? || electricity_rate_params[:electricity_usage].blank?
  end

  def ampere_invalid?
    ampere_valid_list = [10, 15, 20, 30, 40, 50, 60]
    ampere_valid_list.exclude?(electricity_rate_params[:ampere].to_i)
  end
end
