class Users::SessionsController < Devise::SessionsController
  include Devise::Controllers::Rememberable

  prepend_before_action :authenticate_with_two_factor, only: [:create]

  # We need to intercept the create action for processing OTP.
  # Unfortunately we can't override `create` because any code that calls `current_user` will
  # automatically log the user in without OTP. To prevent that, we just have to handle it in
  # a before_action instead

  def authenticate_with_two_factor
    if sign_in_params[:email]
      authenticate_and_start_two_factor
    elsif session[:otp_user_id]
      authenticate_otp_attempt
    end
  end

  def authenticate_and_start_two_factor
    self.resource = resource_class.find_by(email: sign_in_params[:email])
    return unless resource.otp_required_for_login?

    if resource.valid_password?(sign_in_params[:password])
      session[:remember_me] = Devise::TRUE_VALUES.include?(sign_in_params[:remember_me])
      session[:otp_user_id] = resource.id
      render :otp, status: :unprocessable_entity
    else
      # let Devise handle invalid passwords
    end
  end

  def authenticate_otp_attempt
    self.resource = resource_class.find(session[:otp_user_id])

    if resource.verify_and_consume_otp!(params[:otp_attempt])
      session.delete(:otp_user_id)
      remember_me(resource) if session.delete(:remember_me)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource, event: :authentication)
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      flash.now[:alert] = t(".incorrect_verification_code")
      render :otp, status: :unprocessable_entity
    end
  end
end
