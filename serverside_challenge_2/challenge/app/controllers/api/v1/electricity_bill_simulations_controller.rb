# frozen_string_literal: true

module Api
  module V1
    class ElectricityBillSimulationsController < ApplicationController
      def index
        form = ElectricityBillSimulationParams.new(params.permit(:ampere, :kwh))
        return render_validation_errors(form) if form.invalid?

        results = ElectricityBillSimulator.call(ampere: form.ampere, kwh: form.kwh)
        render json: { data: results }, status: :ok
      end

      private

      def render_validation_errors(form)
        render json: { errors: form.jsonapi_errors }, status: :bad_request
      end
    end
  end
end
