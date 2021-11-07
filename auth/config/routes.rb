# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  root to: 'users#index'

  resources :users, only: %i[edit update destroy]
  get '/users/current', to: 'users#current'
end
