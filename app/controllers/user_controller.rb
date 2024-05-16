class UserController < ApplicationController
        def update_balance
          @user = current_user
          amount = params[:cash_in_amount].to_f  # Convert to float for decimal handling
        
          # Basic validation to ensure a positive amount is entered
          if amount <= 0
            flash[:error] = "Please enter a valid cash in amount (positive number)."
            return
          end
        
          ActiveRecord::Base.transaction do
            @user.default_balance += amount
            @user.save!
          end
        
          flash[:notice] = "Successfully added #{'%.2f' % amount} to your balance."
          redirect_to user_portfolio_path(@user)
        end
      
end
