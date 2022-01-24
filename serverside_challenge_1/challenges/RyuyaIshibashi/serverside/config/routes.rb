Rails.application.routes.draw do
  namespace 'api' do
    get '/calculation',   to: 'calculation#execute'
  end
end
