class Admin::UsersController < ApplicationController
    def index
        @users = User.where(admin: false)
    end
    
    # POST /admin/users (form data includes user details)
    def create
        new_user = User.new(user_params)
        new_user.password = Rails.application.credentials.user.default_password
        new_user.skip_confirmation!
        new_user.approved = true

        if new_user.save

        end

        #...
    end

    # GET /admin/pendings
    def pendings
        @pending_users = User.where(admin: false, approved: false)
    end

    # POST /admin/users/:id/approve
    def approve
        @pending_user = User.where(approved: false).find(params[:id])
        @pending_user.approved = true
        @pending_user.save

        #send email ...
        #redirect ...

        # https://rubydoc.info/github/heartcombo/devise/main (devise confirmable)
    end

    private

    def user_params
        params.require(:user).permit(:email, :first_name, :last_name)
    end
end