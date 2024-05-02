class Admin::PendingController < ApplicationController
    def index
        @pending_users = User.where(admin: false, approved: false)
    end
end
