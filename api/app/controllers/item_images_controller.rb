class ItemImagesController < ApplicationController
  def show
    item_image = ItemImage.find_by(id: params[:id])
    render json: item_image
  end

  def index
    item_images = ItemImage.order(created_at: :desc).limit(params[:limit]).offset(params[:offset])
    render json: item_images
  end
end
