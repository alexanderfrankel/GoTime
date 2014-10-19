class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :user_authorized?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_authorized?
  	if current_user
  		return true if current_user.authorized?
  	end
  	return false
  end
end
