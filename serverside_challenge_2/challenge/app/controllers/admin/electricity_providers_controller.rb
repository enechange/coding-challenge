# frozen_string_literal: true

module Admin
  class ElectricityProvidersController < ApplicationController
    def index
      provider = ElectricityProvider.includes(electricity_plans: %i[electricity_plan_basic_fees
                                                                    electricity_plan_usage_fees])
      render json: provider.as_json(
        only: %i[id name],
        include: {
          electricity_plans: {
            only: %i[id name],
            include: {
              electricity_plan_basic_fees: { only: %i[ampere fee] },
              electricity_plan_usage_fees: { only: %i[min_usage fee] }
            }
          }
        }
      ), status: :ok
    end
  end
end
