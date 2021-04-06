class HouseUsersController < ApplicationController
  def show
    @house_user = HouseUser.find(params[:house_user_id])

  end

  def index
    @house_users = HouseUser.all

  end
end
