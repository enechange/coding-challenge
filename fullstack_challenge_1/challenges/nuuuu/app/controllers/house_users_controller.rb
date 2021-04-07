class HouseUsersController < ApplicationController
  include Pagy::Backend
  def show
    @house_user = HouseUser.find(params[:house_user_id])

    @energy_histories_temperature = @house_user.energy_histories.order('ym asc').pluck(Arel.sql("concat(year, '/', month) as ym, temperature"))
    @energy_histories_daylight = @house_user.energy_histories.order('ym asc').pluck(Arel.sql("concat(year, '/', month) as ym, daylight"))
    @energy_histories_energy_production = @house_user.energy_histories.order('ym asc').pluck(Arel.sql("concat(year, '/', month) as ym, energy_production"))
  end

  def index
    house_users = HouseUser.order(id: :asc)
    @pagy, @house_users = pagy(house_users, items: 20)
  end
end
