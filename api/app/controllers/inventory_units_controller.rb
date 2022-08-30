class InventoryUnitsController < ApplicationController
  def show
    inventory_unit = InventoryUnit.find(params[:id])
    render json: inventory_unit
  end

  def index
    inventory_units = InventoryUnit.order(created_at: :desc).limit(params[:limit]).offset(params[:offset])
    render json: inventory_units
  end
end
