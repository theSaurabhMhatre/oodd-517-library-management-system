class ApplicationController < ActionController::Base
  TYPE_STUDENT = "student"
  TYPE_LIBRARIAN = "librarian"
  TYPE_ADMIN = "admin"
  # modification to allow js files to be generated and requested dynamically
  # modifications starts
  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :js_request?

  protected

  def js_request?
    request.format.js?
  end

  #modification ends

  def current_user
    if session[:user_id]
      case session[:user_type]
      when TYPE_STUDENT
        @current_user ||= Student.find(session[:user_id])
      when TYPE_LIBRARIAN
        @current_user ||= Librarian.find(session[:user_id])
      when TYPE_ADMIN
        @current_user ||= Admin.find(session[:user_id])
      end
    else
      @current_user = nil
    end
  end

  helper_method :current_user

  def authorize
    redirect_to login_url if current_user.nil?
  end
end
