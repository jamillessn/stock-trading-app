class PortfoliosController < ApplicationController
  before_action :set_user
  before_action :set_iex_client, only: [:show, :sell_stock]
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

  def sell
    @stock = Stock.find_by(symbol: params[:symbol])

  end

  def sell_stock
    symbol = params[:symbol]
    company_name = params[:company_name]
    quantity = params[:quantity].to_i
  
    # Check if the user has enough shares to sell
    stock = Stock.find_or_initialize_by(user: @user, symbol: symbol)
    if quantity > stock.shares
      flash[:alert] = "You don't have enough shares to sell."
      redirect_to user_portfolio_path(@user.id)
      return
    elsif quantity <= 0
      flash[:alert] = "Please enter a valid quantity."
      redirect_to user_portfolio_path(@user.id)
      return
    end
  
    # Fetch latest price of the stock to be sold.
    price = @iex_client.quote(symbol).latest_price 
  
    # Calculate the total cost of the stock to be sold.
    total_cost = price.round(2) * quantity
  
    ActiveRecord::Base.transaction do
      stock.company_name = company_name
      stock.shares -= quantity
      stock.cost_price = price
      stock.save!
  
      # Create a transaction.
      Transaction.create!(
          action_type: 'Sell',
          company_name: company_name,
          shares: quantity,
          cost_price: total_cost,
          user: @user,
          stock: stock,
          price: price
      )
      
      if stock.shares == 0
        stock.destroy!
      end
  
      # Update the user's default_balance.
      @user.update!(default_balance: @user.default_balance + total_cost)
      flash[:notice] = "Stock sold successfully."
    end
  
    redirect_to user_portfolio_path(@user.id)
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
