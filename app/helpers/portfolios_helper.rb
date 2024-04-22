# app/helpers/portfolios_helper.rb
module PortfoliosHelper
  def calculate_total_portfolio_value
    current_user.holdings.sum do |holding|
      holding.quantity * holding.stock.latest_price
    end
  end
end
