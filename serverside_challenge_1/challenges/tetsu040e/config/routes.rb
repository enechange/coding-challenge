Rails.application.routes.draw do
  get "/plan/simurate" => "plan#simurate"

  get "*not_found"  => "application#routing_error"
  post "*not_found" => "application#routing_error"
end
