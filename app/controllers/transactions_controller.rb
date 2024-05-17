class TransactionsController < ApplicationController
    before_action :set_user
    def index
        @transactions = @user.transactions
    end

    private

    def transaction_params # the ||= symbol is memoization / caching
       @transaction_params ||= params.require(:transaction).permit(:stock_symbol, :shares, :action_type)
    end

    def set_user
        @user = current_user
    end

end
