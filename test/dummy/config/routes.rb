Rails.application.routes.draw do
  root to: "home#index"
  resources :home, only: [:show]

  mount NoPassword::Engine => "/p"
end
