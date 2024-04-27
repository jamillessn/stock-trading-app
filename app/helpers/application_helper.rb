module ApplicationHelper
    #Sidebar only renders when user is logged in
    def user_logged_in?
        current_user.present?
    end
end
