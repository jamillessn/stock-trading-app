class PortfoliosController < ApplicationController
  before_action :set_user
  before_action :set_iex_client, only: [:show]
  helper_method :calculate_total_portfolio_value

  def show
    @user_stocks = @user.stocks.includes(:transactions)
    @stock_values = {}
    @user_stocks.each do |stock|
      @stock_values[stock.symbol] = {
        current_price: @iex_client.quote(stock.symbol).latest_price,
        total_value: @iex_client.quote(stock.symbol).latest_price * stock.shares
      }
    end
  end
  
  def calculate_total_portfolio_value
    @user_stocks.sum do |stock|
      @stock_values[stock.symbol][:total_value]
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_iex_client
    @iex_client = IEX::Api::Client.new(publishable_token: 'sk_619859abf5064fdca965e6d5ad0b9aac')
  end

  
end