class Api::V1::ProvidersController < ApplicationController

  def index
    render json: {
      status: 200,
      data: Provider.all.as_json(
        include: {
          plans: { include: [:basic_charges, :pay_as_you_go_fees] }
        }
      )
    }
  end
end
