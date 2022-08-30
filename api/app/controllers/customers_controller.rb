class CustomersController < ApplicationController
  def show
    customer = Customer.find(params[:id])
    render json: customer
  end

  def index
    customers = Customer.order(created_at: :desc).limit(params[:limit]).offset(params[:offset])
    render json: customers
  end
end
