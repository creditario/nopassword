Rails.application.routes.draw do
  root to: "home#index"
  mount NoPassword::Engine => "/p"
end
