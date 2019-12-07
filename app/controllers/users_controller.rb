class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :destroy, :edit, :update]
  require 'will_paginate/array'

  def index
    unless has_permission?("user_view")
      render "roles/no_permission", layout: 'home'
      return
    end

    @per_page = params[:per_page] || User.per_page || 20
    @users = current_store.members.map{|m| m.user}.paginate(:page => params[:page], :per_page => @per_page)
  end

  def new
    unless has_permission?("user_new")
      render "roles/no_permission", layout: 'home'
      return
    end

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
    unless has_permission?("user_view")
      render "roles/no_permission", layout: 'home'
    end
  end

  def edit
    if @user != current_user
      unless has_permission?("user_edit")
        render "roles/no_permission", layout: 'home'
      end
    end
  end

  def update
    if params[:user].present?
      # Update My Account
      if @user == current_user
        change_password = true
        if params[:user][:current_password].blank? || params[:user][:password].blank?
          params[:user].delete(:current_password)
          params[:user].delete(:password)
          params[:user].delete(:password_confirmation)
          change_password = false
        end

        if change_password
          if @user.update_with_password(user_params)
            bypass_sign_in(@user)
          end
        else
          @user.update(user_params)
        end
      else
        # Update user in store
        if params[:user][:password].blank?
          params[:user].delete(:password)
          params[:user].delete(:password_confirmation)
        end

        if @user.update(user_params)
          member = current_store.members.where(user_id: @user.id).first
          member.update(member_params)
          # Should logout member and must re-login
          redirect_to users_path, notice: "Cập nhật người dùng thành công"
        end
      end
    else
      # That case only update role for member
      member = current_store.members.where(user_id: @user.id).first
      member.update(member_params)
      redirect_to users_path, notice: "Cập nhật vai trò thành công"

      # Should logout member and must re-login
    end
  end

  def destroy
    unless has_permission?("user_delete")
      render "roles/no_permission", layout: 'home'
      return
    end

    if current_store.user == @user
      redirect_to users_path, alert: "Bạn không thể xóa người dùng này"
    else
      @user.status = :archived
      if @user.save
        redirect_to users_path
      else
        redirect_to users_path, alert: "Có lỗi khi xóa người dùng này. Vui lòng thử lại"
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:fullname, :username, :email, :password, :password_confirmation, :current_password, :phone, :birthday, :province_id, :district_id, :commune_id, :address)
  end

  def member_params
    params.require(:member).permit(:user_id, :store_id, :role_id, :branch_id)
  end

  def set_user
    @user = User.find(params[:id])
  end
end