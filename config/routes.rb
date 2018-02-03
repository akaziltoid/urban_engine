Rails.application.routes.draw do
  root 'home#index'

  namespace :listener do
    resources :location_updates, only: :create
  end
end
