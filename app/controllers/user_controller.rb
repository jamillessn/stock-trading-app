class UserController < ApplicationController
  before_action :set_user

  def update_balance
    amount = params[:user][:cash_in_amount].to_f  # Convert to float for decimal handling
  
    # Basic validation to ensure a positive amount is entered
    if amount <= 0
      flash[:error] = "Please enter a valid cash in amount (positive number)."
      redirect_to user_portfolio_path and return
    end
  
    ActiveRecord::Base.transaction do
      @user.default_balance += amount
      @user.save!
    end
  
    session[:user_default_balance] = @user.default_balance
    
    flash[:notice] = "Successfully added #{'%.2f' % amount} to your balance."
    redirect_to user_portfolio_path
  end

  private

  def set_user
    @user = current_user  
  end
end
