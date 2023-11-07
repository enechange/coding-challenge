# frozen_string_literal: true

module Api
  class PricesController < ApplicationController
    before_action :set_prices_service, only: [:index]
    before_action :validate, only: [:index]

    def index
      data = YAML.load_file(Rails.root.join('db/seeds/prices.yaml'))

      companies = data['companies']

      ampere = params[:ampere].to_i
      volume = params[:volume].to_i

      res = @service.create_response(ampere, volume, companies)

      render json: res, status: :ok
    end

    private

    def set_prices_service
      @service = PricesService.new
    end

    def validate
      errors = @service.validate_params(params)

      return if errors.blank?

      render json: errors, status: :bad_request
    end
  end
end
