class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    # Add a debug message to the flash
    flash.now[:alert] = "Please sign in to continue." if flash.empty?
    super
  end

  # POST /resource/sign_in
  def create
    # Add logging to help debug login issues
    Rails.logger.info "Attempting login for email: #{params[:user][:email]}"
    
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    
    Rails.logger.info "Login successful for: #{resource.email}"
    flash[:notice] = "Welcome back, #{resource.email.split('@').first}!"
    
    respond_with resource, location: after_sign_in_path_for(resource)
  rescue => e
    Rails.logger.error "Login error: #{e.message}"
    flash[:alert] = "Login failed. Please check your email and password."
    redirect_to new_user_session_path
  end

  # DELETE /resource/sign_out
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    flash[:notice] = "Signed out successfully." if signed_out
    yield if block_given?
    respond_to_on_destroy
  end

  protected

  def after_sign_in_path_for(resource)
    dashboard_path
  end
  
  def respond_to_on_destroy
    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
    end
  end
end 