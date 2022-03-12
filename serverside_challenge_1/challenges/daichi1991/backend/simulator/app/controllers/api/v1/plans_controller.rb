module Api
  module V1
    class PlansController < ApplicationController
      def index
        get_ampere = params[:ampere]
        get_kwh = params[:kwh]
        if get_ampere !~ /^[0-9]+$/ || get_kwh !~ /^[0-9]+$/
          response_bad_request
        elsif get_kwh.to_i > 999_999_999
          response_bad_request
        else
          result = Plan.get_data(get_ampere, get_kwh)
          response_success(result)
        end
      end
    end
  end
end
