class CustomerAddressesController < ApplicationController
  def show
    customer_address = CustomerAddress.find(params[:id])
    render json: customer_address
  end

  def index
    customer_addresses = CustomerAddress.order(created_at: :desc).limit(params[:limit]).offset(params[:offset])
    render json: customer_addresses
  end
end
