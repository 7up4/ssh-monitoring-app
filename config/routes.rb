Rails.application.routes.draw do
  # Devise configuration
  devise_for :users
  resources :users, :only => [:show] do
    collection do
      get :connect
      post :connect
    end
  end

  root to: "users#connect"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
