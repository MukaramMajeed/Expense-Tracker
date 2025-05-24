class DiagnosticsController < ApplicationController
  def auth_status
    @user_signed_in = user_signed_in?
    @current_user = current_user
    @session_data = {
      warden: session['warden.user.user.key'],
      devise: session['devise.user_attributes'],
      session_id: session.id,
      session_keys: session.keys
    }
    
    render json: {
      user_signed_in: @user_signed_in,
      current_user: @current_user.present? ? {
        id: @current_user.id, 
        email: @current_user.email,
        currency_preference: @current_user.currency_preference
      } : nil,
      session_data: @session_data
    }
  end
end 