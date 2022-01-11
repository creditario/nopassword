NoPassword::Engine.routes.draw do
  resources :sessions, only: [:new, :create]

  get "/confirmations/:token", to: "session_confirmations#edit", as: :session_confirmation
  get "/confirmations", to: "session_confirmations#edit", as: :edit_session_confirmations
  resource :session_confirmations, path: :confirmations, only: [:edit, :update]
end
