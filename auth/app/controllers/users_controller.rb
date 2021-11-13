# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!, except: [:current]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/current.json
  def current
    respond_to do |format|
      format.json { render json: current_user }
    end
  end

  # GET /users/1/edit
  def edit; end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      new_role = @user.role_changed? ? user_params[:role] : nil

      if @user.update(user_params)
        # ----------------------------- produce event -----------------------
        event = {
          event_name: 'UserUpdated',
          data: user_params.to_h.merge(public_id: @user.public_id)
        }
        EventProducer.produce_sync(payload: event.to_json, topic: 'users-stream')

        if new_role
          event = {
            event_name: 'UserRoleChanged',
            data: { public_id: @user.public_id, new_role: new_role }
          }
          EventProducer.produce_sync(payload: event.to_json, topic: 'users-role-changes')
        end

        # --------------------------------------------------------------------

        format.html { redirect_to root_path, notice: 'User was successfully updated.' }
        format.json { render :index, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  #
  # in DELETE action, CUD event
  def destroy
    @user.update(active: false, disabled_at: Time.now)

    # ----------------------------- produce event -----------------------
    event = {
      event_name: 'UserDeleted',
      data: { public_id: @user.public_id }
    }
    EventProducer.produce_sync(payload: event.to_json, topic: 'users-stream')
    # --------------------------------------------------------------------

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def current_user
    if doorkeeper_token
      User.find(doorkeeper_token.resource_owner_id)
    else
      super
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:role, :name)
  end
end
