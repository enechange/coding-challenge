# frozen_string_literal: true

module ElectricityChargeCalculator::Tepco
  class StandardSService
    include ElectricityChargeCalculator::CalculateConcern

    def initialize(plan:, ampere:, usage:)
      @plan   = plan
      @ampere = ampere
      @usage  = usage
    end

    def call
      {
        status:        :success,
        provider_name: plan.provider.name,
        plan_name:     plan.name,
        price:         calcurate_charge
      }
    rescue App::DataNotFound => e
      {
        status:        :error,
        provider_name: plan.provider.name,
        plan_name:     plan.name,
        message:       e.to_s
      }
    end

    private

    def calcurate_charge
      basic_charge + usage_charge
    end

    def basic_charge
      super
    end

    def usage_charge
      super
    end

    attr_reader :plan, :ampere, :usage
  end
end
