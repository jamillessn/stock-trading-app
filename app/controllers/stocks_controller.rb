class StocksController < ApplicationController
  require 'iex-ruby-client'
  before_action :set_iex_client

  def index
    # Cache the list of most active stocks for 10 minutes
    @stocks = Rails.cache.fetch("most_active_stocks", expires_in: 10.minutes) do
      @iex_client.stock_market_list(:mostactive).take(10)
    end
  
    @user = current_user
  
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
    symbol = params[:symbol]
    company_name = params[:company_name]
    quantity = params[:quantity].to_i
    user = current_user
  
    price = @iex_client.quote(symbol).latest_price  # Fetch latest price
    total_cost = price * quantity
  
    # Check if the user has enough balance
    
    if user.default_balance < total_cost
      flash[:error] = 'Insufficient funds to complete this transaction'
      redirect_to stocks_path
      return
    end
  
    ActiveRecord::Base.transaction do
      # Create or update the stock record
      stock = user.stocks.find_or_initialize_by(symbol: symbol)
      stock.company_name = company_name
      stock.shares = (stock.shares || 0) + quantity
      stock.cost_price = price  # This might need adjustment based on your schema
      stock.save!
  
      # Create the transaction record
      Transaction.create!(
        action_type: 'Buy',
        company_name: company_name,
        shares: quantity,
        cost_price: total_cost,
        user: user,
        stock: stock,
        price: price
      )
  
      # Update user's balance
      Rails.logger.info "Before Update: #{user.default_balance}"
      Rails.cache.delete("user_#{user.id}_balance")

      user.default_balance -= total_cost
      user.save!
      
      Rails.logger.info "After Update: #{user.reload.default_balance}"
    end
  
    flash[:notice] = "Stock bought successfully."
    redirect_to user_portfolio_path(user.id)
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
