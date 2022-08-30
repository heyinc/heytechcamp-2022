class SalesChannelsController < ApplicationController
  def show
    sales_channel = SalesChannel.find(params[:id])
    render json: sales_channel
  end

  def index
    sales_channels = SalesChannel.order(created_at: :desc).limit(params[:limit]).offset(params[:offset])
    render json: sales_channels
  end
end
