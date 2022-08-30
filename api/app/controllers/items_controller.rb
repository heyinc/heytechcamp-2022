class ItemsController < ApplicationController
  def show
    item = Item.find(params[:id])
    render json: item
  end

  def index
    items = Item.order(created_at: :desc).limit(params[:limit]).offset(params[:offset])
    render json: items
  end
end
