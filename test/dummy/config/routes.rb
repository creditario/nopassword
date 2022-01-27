Rails.application.routes.draw do
  resources :home, only: [:show]

  mount NoPassword::Engine => "/p"
  root to: "home#index"
end
