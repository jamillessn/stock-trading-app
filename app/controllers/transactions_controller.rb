class TransactionsController < ApplicationController
    def index
        @transactions = current_user.transactions
    end

    def buy
        Transaction.buy_shares!(current_user, transaction_params)
        redirect_to user_portfolio_path
    rescue ActiveRecord::RecordInvalid
        render :buy
    end

    def sell
        Transaction.sell_shares!(current_user, transaction_params)
        redirect_to user_portfolio_path
    rescue ActiveRecord::RecordInvalid
        render :sell
    end

    private

    def transaction_params # the ||= symbol is memoization / caching
       @transaction_params ||= params.require(:transaction).permit(:stock_symbol, :shares, :action_type)
    end

end
