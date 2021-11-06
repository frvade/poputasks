# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_account!, only: [:index]

  # GET /accounts
  # GET /accounts.json

  def index
  end
end
