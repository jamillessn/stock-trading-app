class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    end
  
    def after_sign_in_path_for(resource)
      if resource.admin?
        admin_users_path
      else
        user_portfolio_path(@user)
      end
    end
  end
  