# frozen_string_literal: true

module Api
  module V1
    class PlansController < ApplicationController
      include Constants

      before_action :set_params
      before_action :validate_params

      def list
        totals = ProviderService.calculate(@ampere, @usage)
        providers_info = ProviderService.providers_info(@ampere)
        generated_data = generate_data(totals, providers_info)

        render JsonResponse.ok(generated_data)
      end

      private

      def set_params
        @ampere = params[:ampere]
        @usage = params[:usage]
      end

      def validate_params
        validator = Validator.new(@ampere, @usage)
        if validator.valid?
          @ampere = validator.ampere.to_i
          @usage = validator.usage.to_i
        else
          error_messages = validator.errors.full_messages.join(', ')
          render JsonResponse.unprocessable_entity(error_messages)
        end
      end

      def generate_data(totals, providers_info)
        providers_info.map do |provider, info|
          {
            provider_name: info.keys.first,
            plan_name: info.values.first,
            price: totals[provider]
          }
        end
      end
    end
  end
end
