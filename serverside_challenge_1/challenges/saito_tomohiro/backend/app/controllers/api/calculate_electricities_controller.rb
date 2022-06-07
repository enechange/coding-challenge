module Api
  class CalculateElectricitiesController < ApplicationController
    before_action :validate_params_ampere, only: [:simulate]
    before_action :validate_params_usage, only: [:simulate]

    def simulate
      res = CalculateElectricity.new(simulate_params).result
      render json: res
    end

    private

    def simulate_params
      params.permit(
        :ampere,
        :usage
      )
    end

    def validate_params_ampere
      return response_bad_request('アンペア数を指定してください') if params[:ampere].blank?
    end

    def validate_params_usage
      return response_bad_request('使用量を指定してください') if params[:usage].blank?
      return response_bad_request('使用量は0以上の数字で指定してください') if params[:usage].match(/[^0-9]/)
    end
  end
end
