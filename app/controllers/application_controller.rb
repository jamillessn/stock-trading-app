class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller? #Enables devise to recognize first_name and last_name for registration
    before_action :authenticate_user!

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    end

    def after_sign_in_path_for(resource)
        # Redirect the user to their portfolio page after logging in
        user_portfolio_path(current_user)
      end
end
