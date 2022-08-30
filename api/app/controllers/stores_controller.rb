class StoresController < ApplicationController
  def show
    store = Store.find(params[:id])
    render json: store
  end

  def index
    stores = Store.order(created_at: :desc).limit(params[:limit]).offset(params[:offset])
    render json: stores
  end
end
