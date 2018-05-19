class ProducersController < ApplicationController
  before_action :set_producer, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  include ApplicationHelper

  def index
    @producers = Producer.by_store(current_store.id)
  end

  def create
    @producer = Producer.new(producer_params)
    @producer.user = current_user
    @producer.store = current_store
    @product_group.save
  end

  def destroy
    @product_group.destroy
  end

  private
  def set_producer
    @producer = Producer.find(params[:id])
  end

  def producer_params
    params.require(:producer).permit(:name)
  end
end