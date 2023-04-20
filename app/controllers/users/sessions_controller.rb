class Users::SessionsController < Devise::SessionsController
  include Devise::Controllers::Rememberable

  # We need to intercept the Sessions#create action for processing OTP
  prepend_before_action :authenticate_with_two_factor, only: [:create]

  def authenticate_with_two_factor
    if sign_in_params[:email]
      self.resource = resource_class.find_by(email: sign_in_params[:email])

      # Any new login attempt should reset 2FA user
      clear_otp_user_from_session

      # Intercept Devise if 2FA required. Otherwise let Devise handle non-2FA auth
      authenticate_and_start_two_factor if resource&.otp_required_for_login?
    elsif session[:otp_user_id]
      authenticate_otp_attempt
    end
  end

  def authenticate_and_start_two_factor
    if resource.valid_password?(sign_in_params[:password])
      session[:remember_me] = Devise::TRUE_VALUES.include?(sign_in_params[:remember_me])
      session[:otp_user_id] = resource.id
      render :otp, status: :unprocessable_entity
    else
      # Let Devise handle invalid passwords
    end
  end

  def authenticate_otp_attempt
    self.resource = resource_class.find(session[:otp_user_id])

    if resource.verify_and_consume_otp!(params[:otp_attempt])
      clear_otp_user_from_session
      remember_me(resource) if session.delete(:remember_me)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource, event: :authentication)
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      flash.now[:alert] = t(".incorrect_verification_code")
      render :otp, status: :unprocessable_entity
    end
  end

  def clear_otp_user_from_session
    session.delete(:otp_user_id)
  end
end
