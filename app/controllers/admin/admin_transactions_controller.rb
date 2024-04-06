class Admin::AdminTransactionsController < ApplicationController
    def index
        @transactions = Transaction.all
    end
end
