class Admin::UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:show, :edit, :update, :destroy, :approve_user]
  
    def index
      @users = User.where(admin: false)
    end
    
    def new
      @user = User.new
    end
  
    def update
      @user.update!(user_params)
      redirect_to admin_users_path
    end
  
    def destroy
      ActiveRecord::Base.transaction do
        @user.transactions.destroy_all
        @user.stocks.destroy_all
        @user.destroy
      end
      redirect_to admin_users_path, notice: "User #{@user.email} has been deleted."
    rescue ActiveRecord::RecordNotDestroyed
      redirect_to admin_users_path, alert: "Failed to delete user due to associated records."
    end
  
    def create
      @user = User.new(user_params)
      @user.password = params[:user][:password]
      @user.default_balance = 0.0
      @user.skip_confirmation!
      @user.approved = true
  
      if @user.save
        UserMailer.with(user: @user).welcome_email.deliver_later
        redirect_to admin_users_path
        flash[:notice] = "User #{@user.email} successfully created."
      else
        flash[:alert] = "Failed to add user."
      end
    end
  
    def pendings
      @pending_users = User.where(admin: false, approved: false)
    end
  
    def approve_user
      user = User.find(params[:id])
      user.approved = true
      if user.save
        UserMailer.with(user: user).approval_email.deliver_later
        flash[:notice] = "#{user.email} approved"
      else
        flash[:alert] = "#{user.email} approval failure"
      end
  
      redirect_to admin_users_path
    end
  
    private
  
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name)
    end
  
    def set_user
      @user = User.find(params[:id])
    end
  end
  