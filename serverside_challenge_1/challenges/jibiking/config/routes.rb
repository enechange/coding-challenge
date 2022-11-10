Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      post "providers", to: "providers#import"
      post "plans", to: "plans#import"
      post "amperages", to: "amperages#import"
      post "kilowattos", to: "kilowattos#import"
      get "suggests", to: "suggests#calc"
    end
  end
end