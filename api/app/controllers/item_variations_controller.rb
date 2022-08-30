class ItemVariationsController < ApplicationController
  def show
    item_variation = ItemVariation.find(params[:id])
    render json: item_variation
  end

  def index
    item_variations = ItemVariation.order(created_at: :desc).limit(params[:limit]).offset(params[:offset])
    render json: item_variations
  end
end
