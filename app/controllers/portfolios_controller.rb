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

  def create
    ActiveRecord::Base.transaction do
      stocks = @user.stock.find_or_initialize_by(symbol: stock.symbol)
      @symbol = params[:symbol]
      @quantity = params[:quantity].to_i

      # Implement your logic to handle the stock purchase here
        if action == 'Buy'
          total_cost = price * quantity
        if total_cost > @user.default_balance
          return { success: false, message: 'Insufficient funds to complete this transaction' }
        end

        @user.default_balance -= total_cost
        stocks.share = (stocks.share || 0) + quantity

      elsif action == 'Sell'
        
          unless stock
            return { success: false, message: 'Stock not found' }
          end
    
          #Find portfolio for a stock 
          #Validates if the user has sufficent shares for the sell order
          stock = @user.stock.find_by(stock: stock)
          if stock.nil? || stock.share < quantity
            return { success: false, message: 'Not enough shares to sell' }
          end
    
          price = @iex_client.quote(stock.symbol).latest_price
          total_revenue = price * quantity
          
          @user.default_balance += total_revenue
          
          # Update portfolio or destroy if no shares remain
          stock.share -= quantity

          if stock.share <= 0
            stock.destroy!
          else
            stock.save!
          end
          
          # Save changes to the user
          @user.save!
          create_transaction(stock, quantity, 'sell', price)

        end
      rescue StandardError => e
        return { success: false, message: e.message }
      end
    
    # Redirect or render depending on your application's flow
    redirect_to user_portfolio_path, notice: 'Stock bought successfully.'
  end

  private

  def set_user
    @user = current_user
  end

  def set_iex_client
    @iex_client = IEX::Api::Client.new(publishable_token: 'sk_d67df174e2e247d59c359c10448bd0c8')
  end
  
end