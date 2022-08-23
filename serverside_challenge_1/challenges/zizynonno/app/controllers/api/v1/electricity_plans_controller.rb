module Api
  module V1
    class ElectricityPlansController < ApplicationController
      def index
        render json: { status: 'success', data: "aaaa" }
      end
    end
  end
end
