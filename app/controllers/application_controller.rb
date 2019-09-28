class ApplicationController < ActionController::Base
  # modification to allow js files to be generated and requested dynamically
  # modifications starts
  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :js_request?

  protected

  def js_request?
    request.format.js?
  end
  #modification ends

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
