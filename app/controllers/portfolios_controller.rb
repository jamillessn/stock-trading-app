# class PortfoliosController < ApplicationRecord
class PortfoliosController < ApplicationController
  # before_action :authenticate_user!  # Ensures the user is logged in

  def show
    @holdings = current_user.holdings.includes(:stock) # Eager load stocks for efficiency
  end
end
