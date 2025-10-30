# frozen_string_literal: true

class Api::V1::ElectricityChargesController < ApplicationController
  def index
    ampere = params[:ampere]
    usage = params[:usage]

    if ampere.blank? || usage.blank?
      return render(
        json: { error: I18n.t('api.v1.electricity_charges.errors.missing_parameters') },
        status: :bad_request,
      )
    end

    results = Plan.includes(:provider, :basic_charges, :usage_charges).filter_map do |plan|
      price = ElectricityChargeCalculator.execute!(plan: plan, ampere: ampere, usage: usage)
      next if price.nil?

      { provider_name: plan.provider.name, plan_name: plan.name, price: price }
    end

    render(json: results, status: :ok)
  rescue ElectricityChargeCalculator::InvalidInputError,
         ElectricityChargeCalculator::InvalidUsageError,
         ElectricityChargeCalculator::InvalidAmpereError => e
    render(json: { error: e.message }, status: :bad_request)
  rescue StandardError => e
    error_message = I18n.t('api.v1.electricity_charges.errors.internal_server_error')
    Rails.logger.error("#{error_message}: #{e.message}")
    render(json: { error: error_message }, status: :internal_server_error)
  end
end
