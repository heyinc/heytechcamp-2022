class OrdersController < ApplicationController
  def show
    order = Order.find(params[:id])
    render json: order
  end

  def index
    orders = Order.order(created_at: :desc).limit(params[:limit]).offset(params[:offset])
    render json: orders
  end
end
