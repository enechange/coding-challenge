Rails.application.routes.draw do
  namespace 'api' do
    get 'simulated_electricity_fee', to: 'simulated_electricity_fee#every_plan'
  end
end
