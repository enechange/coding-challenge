class HouseUsersController < ApplicationController
  include Pagy::Backend
  def show
    @house_user = HouseUser.find(params[:house_user_id])

  end

  def index
    house_users = HouseUser.order(id: :asc)
    @pagy, @house_users = pagy(house_users, items: 20)
  end
end
