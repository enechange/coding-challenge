# frozen_string_literal: true

module Api
  class CalculationsController < ApplicationController
    before_action :validate_params!

    def fee_by_plan
      render json: CalculateFee.call(params[:ampere], params[:usage])
    end

    private

    def validate_params!
      if params[:ampere].blank?
        raise ApplicationError::BadRequestError, '契約アンペア数が入力されていません'
      elsif (Regexp.new('^(10|15|20|30|40|50|60)$') =~ params[:ampere]) != 0
        raise ApplicationError::BadRequestError, '契約アンペア数に不正な値が設定されています'
      end

      if params[:usage].blank?
        raise ApplicationError::BadRequestError, '電気使用量が入力されていません'
      elsif (Regexp.new('^[0-9]+*$') =~ params[:usage]) != 0
        raise ApplicationError::BadRequestError, '電気使用量が指定されておりません'
      end
    end
  end
end
