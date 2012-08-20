class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
  	Rails.logger.debug "*** request is #{request.env['omniauth.auth'].to_json}" 
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end