class TransactionsController < ApplicationController
    def index
        @transactions = current_user.transactions
        
    end

    def create
        @transaction = Transaction.new(transaction_params)
        #..
        params[:action_type] # could be "buy" or "sell"
        #..

        if @transaction.save
            if params[:action_type] = "buy"
                # add shares to user's portfolio
            elsif params[:action_type] = "sell"
                # subtract shares to user's portfolio
            end
        else

        end

    end

    def buy
        # @transaction = Transaction.buy(transaction_params) --> 

        @transaction = Transaction.new(transaction_params)

        if @transaction.save
            stock = current_user.stocks.find_or_create_by(stock_symbol: transaction_params[:stock_symbol])
            stock.shares += transaction_params[:shares] # -> //set default value of shares in database to 0 so it wont be nil.
            
            if stock.save
                #..
            else
                #..
            end

        else
            #...
        end
    end

    def sell
        @transaciont = Transaction.new(transaction_params)
    end
    private

    def transaction_params # the ||= symbol is memoization / caching
       @transaction_params ||= params.require(:transaction).permit(:stock_symbol, :shares, :action_type)
    end

end
