Rails.application.routes.draw do
  get "show", to: "home#show", as: :secure_area

  mount NoPassword::Engine => "/p"
  root to: "home#index"
end
