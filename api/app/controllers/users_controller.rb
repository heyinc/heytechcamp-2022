class UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    render json: user
  end

  def index
    users = User.order(created_at: :desc).limit(params[:limit]).offset(params[:offset])
    render json: users
  end
end
