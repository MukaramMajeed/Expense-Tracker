class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    # If we're only updating currency_preference and not the password or email
    if only_currency_update?
      if resource.update_without_password(currency_only_params)
        bypass_sign_in resource, scope: resource_name
        flash[:notice] = "Currency preference has been updated successfully."
        redirect_to after_update_path_for(resource) and return
      else
        render :edit and return
      end
    end

    # Otherwise, proceed with the regular update method
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  protected

  # Check if we're only updating the currency preference
  def only_currency_update?
    params[:user][:password].blank? && 
    params[:user][:password_confirmation].blank? && 
    params[:user][:email] == resource.email &&
    params[:user][:currency_preference].present?
  end

  # Parameters for currency-only update
  def currency_only_params
    params.require(:user).permit(:currency_preference)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:currency_preference])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:currency_preference])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def after_update_path_for(resource)
    dashboard_path
  end
  
  def sign_in_after_change_password?
    true
  end
end 