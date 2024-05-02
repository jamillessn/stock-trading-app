# app/helpers/portfolios_helper.rb
module PortfoliosHelper
  def calculate_total_portfolio_value
    if current_user.stocks.exists?
        current_user.stocks.sum do |stock|
          stock.shares * stock.latest_price
        end
    end
  end
end
