class HouseUsersController < ApplicationController
  def show

  end

  def index
    @house_users = HouseUser.all

  end
end
