Rails.application.routes.draw do
  get "/plan/compare" => "plan#compare"

  get "*not_found" => "application#routing_error"
  post "*not_found" => "application#routing_error"
end
