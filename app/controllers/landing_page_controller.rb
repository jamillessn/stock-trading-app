class LandingPageController < ApplicationController
  before_action :sign_out_user_if_signed_in
  
  private

  def sign_out_user_if_signed_in
    sign_out(current_user) if user_signed_in?
  end

end
