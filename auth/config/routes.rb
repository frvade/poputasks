# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :accounts, controllers: {
    registrations: 'accounts/registrations',
    sessions: 'accounts/sessions'
  }

  root to: "accounts#index"
end
