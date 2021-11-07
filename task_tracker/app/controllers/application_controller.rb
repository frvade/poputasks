# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def authenticate_user!
    redirect_to login_path unless current_user
  end

  private

  def current_user
    return unless session[:user_id] && session[:expires_at]

    @current_user ||= User.find_by_id(session[:user_id]) unless session[:expires_at] < Time.now.to_i
  end
  helper_method :current_user
end
