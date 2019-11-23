class RolesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  def new
    @role = Role.new
  end

  def create
    @user = User.find(params[:user_id])

    @role = Role.new(role_params)
    @role.store = current_store

    if @role.save
      redirect_to user_path(@user, anchor: "role-content")
    end
  end

  def edit

  end

  def update
    if @role.update(role_params)
      @user = User.find(params[:user_id])
      redirect_to user_path(@user, anchor: "role-content")
    end
  end

  def destroy

  end

  private
  def set_role
    @role = Role.find(params[:id])
  end
  def role_params
    params.require(:role).permit(:name, permissions: [])
  end
end