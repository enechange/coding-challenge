class Api::V1::PlansController < ApplicationController
  def index
    result = {
      'code' => 1,
      'message' => t("api.errors.invalid"),
      'data' => []
    }
    render :json => result
  end
end
