Rails.application.routes.draw do
  resources :machines
  resources :users

  # Devise configuration
  devise_for :users
  root to: "users#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
