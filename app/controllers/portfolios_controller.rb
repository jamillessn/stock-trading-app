class PortfoliosController < ApplicationController
  # before_action :authenticate_user!  # Ensures the user is logged in

  def show
    # @holdings = current_user.holdings.includes(:stock) # Eager load stocks for efficiency
    @has_holdings = current_user.stocks.exists?
  end

  def index
    # @has_holdings = current_user.holdings.exists?
    @has_holdings = current_user.stocks.exists?
  end
end
