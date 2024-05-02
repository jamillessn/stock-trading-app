class PortfoliosController < ApplicationController
  before_action :set_user

  def show
    
  end

  private

  def set_user
    current_user
  end


end
