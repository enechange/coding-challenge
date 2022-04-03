module Api
  module V1
    class PlansController < ApplicationController
      def index
        get_ampere = params[:ampere]
        get_kwh = params[:kwh]
        if get_ampere !~ /^[0-9]+$/
          response_bad_request('【エラー】契約アンペア数で0以上の整数以外が入力されています')
        elsif  get_kwh !~ /^[0-9]+$/
          response_bad_request('【エラー】電気使用量で0以上の整数以外が入力されています')
        elsif get_kwh.to_i > 999_999_999
          response_bad_request('【エラー】電気使用量で999,999,999以上の値が入力されています')
        else
          result = Plan.get_data(get_ampere, get_kwh)
          response_success(result)
        end
      end
    end
  end
end
