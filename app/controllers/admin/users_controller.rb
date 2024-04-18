class Admin::UsersController < ApplicationController
    # before_action :authenticate_user!
    # before_action :check_admin

    def index
        if params[:approved] == "false"
            @users = User.where(approved: false)
          else
            @users = User.where(admin: false)
          end
    end
    
    def new
        @user = User.new
    end

    # POST /admin/users (form data includes user details)
    def create
        @user = User.new(user_params)
        @user.password = params[:user][:password]
        @user.skip_confirmation!
        @user.approved = true

        if @user.save
            redirect_to admin_users_path, notice: "User with email #{@user.email} successfully created." 
        else
            render :new
        end

        respond_to do |format|
            if @user.save
              # Tell the UserMailer to send a welcome email after save
              UserMailer.with(user: @user).welcome_email.deliver_later
      
              format.html { redirect_to(@user, notice: 'User was successfully created.') }
              format.json { render json: @user, status: :created, location: @user }
            else
              format.html { render action: 'new' }
              format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    # GET /admin/pendings
    def pendings
        @pending_users = User.where(admin: false, approved: false)
    end

    def approve_user
        user = User.find(params[:id])
        user.approved = true
        if user.save
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

    def check_admin
        redirect_to root_path unless current_user.admin?
    end

    def skip_confirmation
        @user.confirmed_at = Date.now
    end
end