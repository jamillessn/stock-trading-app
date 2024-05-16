class TransactionsController < ApplicationController
    def index
        @transactions = current_user.transactions
    end

    private

    def transaction_params # the ||= symbol is memoization / caching
       @transaction_params ||= params.require(:transaction).permit(:stock_symbol, :shares, :action_type)
    end

end
