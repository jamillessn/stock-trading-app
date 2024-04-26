class StocksController < ApplicationController
  require 'iex-ruby-client'
  before_action :set_iex_client

  def index
    @stocks = @iex_client.stock_market_list(:mostactive) # Or your preferred list
    @user = current_user

     # Dynamically create/update Stock records
      @stocks.each do |iex_stock|
        stock = Stock.find_or_initialize_by(symbol: iex_stock.symbol)
        stock.update(company_name: iex_stock.company_name)
        # Assuming you want to associate the stocks with the current user
        stock.user_id = @user.id
        stock.save
      end

    # Pre-fetch prices for efficiency (your existing code)
    symbols = @stocks.map(&:symbol)
    @stock_prices = {} # Use a hash to store prices

    symbols.each do |symbol|
      @stock_prices[symbol] = @iex_client.quote(symbol)
    end
  end


  def buy
    @stock = Stock.find(params[:id])
    @user = current_user

    quantity = params[:quantity].to_i
    latest_price = @iex_client.quote(@stock.symbol).latest_price
    total_cost = quantity * latest_price

    if @user.balance >= total_cost && quantity >= 1
      ActiveRecord::Base.transaction do # Ensures all database operations succeed or fail together
        @user.balance -= total_cost
        @user.save!

        holding = @user.holdings.find_or_create_by(stock: @stock)
        holding.quantity += quantity
        holding.save!

        Transaction.create!(
          trader: @user,
          stock: @stock,
          action_type: 'Buy',
          quantity: quantity,
          price: latest_price
        )
      end
      flash[:success] = "You bought #{quantity} shares of #{@stock.symbol}"
    else
      # ... error handling (from previous example) ...
    end
    redirect_to stocks_path # Redirect in all cases
  end

  def sell
    @stock = Stock.find(params[:id])
    @user = current_user

    quantity = params[:quantity].to_i
    latest_price = @iex_client.quote(@stock.symbol).latest_price
    total_value = quantity * latest_price

    holding = @user.holdings.find_by(stock: @stock)

    if holding && holding.quantity >= quantity && quantity >= 1
      ActiveRecord::Base.transaction do
        @user.balance += total_value
        @user.save!

        holding.quantity -= quantity
        holding.destroy! if holding.quantity == 0 # Delete holding if no shares left
        holding.save!

        Transaction.create!(
          trader: @user,
          stock: @stock,
          action_type: 'Sell',
          quantity: quantity,
          price: latest_price
        )
      end
      flash[:success] = "You sold #{quantity} shares of #{@stock.symbol}"
    else
       # ... error handling (from previous example) ...
    end
    redirect_to stocks_path # Redirect in all cases
  end

  end

  private

  def set_iex_client
    @iex_client = IEX::Api::Client.new(publishable_token: 'pk_dc485c54f85f46b3b104d7ca13de635d')
  end
