# frozen_string_literal: true

module Admin
  class ElectricityPlansController < ApplicationController
    def upload_csv
      if params[:basic_fee_file].present? && params[:usage_fee_file].present?
        form = PlanCsvForm.new(basic_fee_file: params[:basic_fee_file], usage_fee_file: params[:usage_fee_file])
        if form.save
          render json: {}, status: :ok
        else
          render json: { error: form.errors.full_messages.first }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Both basic fee file and usage fee file must be uploaded' }, status: :bad_request
      end
    end
  end
end
