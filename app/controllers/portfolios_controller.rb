class PortfoliosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show

  end

  def index
   
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
