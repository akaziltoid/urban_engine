Rails.application.routes.draw do
  root 'home#index'

  namespace :listener do
    resources :location_updates, only: :create
  end

  namespace :raw do
    resources :thermostats, only: :show, param: :uuid do
      get :reset, on: :member
    end
    resources :sensor_temperatures, only: :update, param: :uuid
  end
end
