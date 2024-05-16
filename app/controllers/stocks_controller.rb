class StocksController < ApplicationController
  require 'iex-ruby-client'
  before_action :set_iex_client
  before_action :set_user

  def index
    # Cache the list of most active stocks for 10 minutes
    @stocks = Rails.cache.fetch("most_active_stocks", expires_in: 10.minutes) do
      @iex_client.stock_market_list(:mostactive).take(10)
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
    symbol = params[:symbol]
    company_name = params[:company_name]
    quantity = params[:quantity].to_i

    price = @iex_client.quote(symbol).latest_price  # Fetch latest price
    total_cost = price.round(2) * quantity

    # Check if the user has enough balance
    if @user.default_balance < total_cost
        flash[:error] = 'Insufficient funds to complete this transaction'
    else
        ActiveRecord::Base.transaction do
          stock = @user.stocks.find_or_initialize_by(symbol: symbol)
          stock.company_name = company_name
          stock.shares = (stock.shares || 0) + quantity
          stock.cost_price = price
          stock.save!

          Transaction.create!(
              action_type: 'Buy',
              company_name: company_name,
              shares: quantity,
              cost_price: total_cost,
              user: @user,
              stock: stock,
              price: price
          )
          
          @user.update!(default_balance: @user.default_balance =- total_cost)
          flash[:notice] = "Stock bought successfully."

          end
      end

    redirect_to user_portfolio_path(@user.id)
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

  private

  def set_iex_client
    @iex_client = IEX::Api::Client.new(publishable_token: 'sk_d67df174e2e247d59c359c10448bd0c8')
  end

  def set_user
    @user = current_user
  end

end