class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :destroy, :edit, :update]
  require 'will_paginate/array'

  def index
    @per_page = params[:per_page] || User.per_page || 20
    @users = current_store.members.map{|m| m.user}.paginate(:page => params[:page], :per_page => @per_page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @member = Member.new(member_params)
      @member.user_id = @user.id # Set member for this user
      @member.store = current_store
      @member.save

      redirect_to users_path
    end
  end

  def show

  end

  def edit

  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      member = current_store.members.where(user_id: @user.id).first
      member.update(member_params)
      redirect_to users_path, notice: "Cập nhật người dùng thành công"
    end
  end

  def destroy
    if current_store.user == @user
      redirect_to users_path, error: "Bạn không thể xóa người dùng này"
    else
      if @user.destroy
        redirect_to users_path
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:fullname, :username, :email, :password, :password_confirmation, :phone, :birthday, :province_id, :district_id, :commune_id, :address)
  end

  def member_params
    params.require(:member).permit(:user_id, :store_id, :role_id, :branch_id)
  end

  def set_user
    @user = User.find(params[:id])
  end
end