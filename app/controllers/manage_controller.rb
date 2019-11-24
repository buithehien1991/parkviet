class ManageController < ApplicationController
  before_action :authenticate_user!
  before_action :current_store

  def index
  end
end
