# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def sign_in; end

  def create
    if new_user_params[:active]
      user = User.find_by(auth_identity_params) || User.create!(new_user_params)
      user.update(new_user_params)
      session[:user_id] = user.id
      session[:expires_at] = auth_hash['credentials']['expires_at']
    end

    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil

    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

  def new_user_params
    {
      public_id: auth_hash['info']['public_id'],
      email: auth_hash['info']['email'],
      name: auth_hash['info']['name'],
      role: auth_hash['info']['role'],
      active: auth_hash['info']['active']
    }
  end

  def auth_identity_params
    {
      public_id: auth_hash['uid']
    }
  end
end
