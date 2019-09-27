class ApplicationController < ActionController::Base
  def current_admin
    if session[:admin_id]
      @current_admin ||= Admin.find(session[:admin_id])
    else
      @current_admin = nil
    end
  end
  helper_method :current_admin

  def authorize
    redirect_to login_url if current_admin.nil?
  end
end
