NoPassword::Engine.routes.draw do
  resources :sessions, only: [:new, :create]
end
