NoPassword::Engine.routes.draw do
  resources :sessions, only: [:new, :create]
  resources :session_confirmations
end
