class StocksController < ApplicationController
  require 'iex-ruby-client'
  before_action :set_iex_client

  def index
    # Cache the list of most active stocks for 10 minutes
    @stocks = Rails.cache.fetch("most_active_stocks", expires_in: 10.minutes) do
      @iex_client.stock_market_list(:mostactive).take(10)
    end
  
    @user = current_user
  
    # Update database records from cached data
    @stocks.each do |iex_stock|
      stock = Stock.find_or_initialize_by(symbol: iex_stock.symbol)
      stock.update(company_name: iex_stock.company_name)
      stock.save
    end
  
    # Cache stock prices
    symbols = @stocks.map(&:symbol)
    @stock_prices = {}
    symbols.each do |symbol|
      @stock_prices[symbol] = Rails.cache.fetch("#{symbol}_price", expires_in: 10.minutes) do
        @iex_client.quote(symbol)
      end
    end
  
    # Cache logo URLs
    @stock_logos = {}
    symbols.each do |symbol|
      @stock_logos[symbol] = Rails.cache.fetch("#{symbol}_logo", expires_in: 24.hours) do
        @iex_client.logo(symbol).url
      end
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
    @iex_client = IEX::Api::Client.new(publishable_token: 'sk_d67df174e2e247d59c359c10448bd0c8')
  end
