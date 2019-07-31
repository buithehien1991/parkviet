class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_user!

  def index

  end
end