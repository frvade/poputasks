# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "transactions#index"

  get '/login', to: 'sessions#sign_in', as: 'login'
  delete '/logout', to: 'sessions#destroy', as: 'logout'
  get '/auth/:provider/callback', to: 'sessions#create'

  resources :transactions, only: %i[index show] do
    post :payout, on: :collection
  end
end
