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
        raise ApplicationError::BadRequestError, I18n.t('errors.contract_amperage.blank')
      elsif (Regexp.new('^(10|15|20|30|40|50|60)$') =~ params[:ampere]) != 0
        raise ApplicationError::BadRequestError, I18n.t('errors.contract_amperage.invalid')
      end

      if params[:usage].blank?
        raise ApplicationError::BadRequestError, I18n.t('errors.usage.blank')
      elsif (Regexp.new('^[0-9]+*$') =~ params[:usage]) != 0
        raise ApplicationError::BadRequestError, I18n.t('errors.usage.invalid')
      end
    end
  end
end
