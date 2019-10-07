class SessionsController < ApplicationController
  def new
    if session[:user_id] != nil
      redirect_to root_url
    end
  end

  def create
    case params[:user_type]
    when TYPE_STUDENT
      user = Student.find_by_email(params[:email])
    when TYPE_LIBRARIAN
      user = Librarian.find_by_email(params[:email])
    when TYPE_ADMIN
      user = Admin.find_by_email(params[:email])
    end
    if user && user.authenticate(params[:password])
      if (params[:user_type] == TYPE_LIBRARIAN and user.is_approved == 0)
        flash.now[:alert] = "You have not been approved by the admin yet"
        render "new"
      else
        session[:user_id] = user.id
        session[:user_type] = params[:user_type]
        redirect_to root_url, notice: "Logged in!"
      end
    else
      flash.now[:alert] = "Email or password is invalid"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_type] = nil
    redirect_to root_url, notice: "Logged out!"
  end

  #This method is called after a user has authenticated with google.
  #It checks whether the gmail address matches with either of the Admin, Librarian and Student tables.
  #If there is a match, it logs in the user as the correspoding user_type.
  #If there is no match, it flashes an error and redirects the user to the login page.
  def googleAuth
    if Student.exists?(email: request.env["omniauth.auth"]["info"]["email"])
      user = Student.find_by_email(request.env["omniauth.auth"]["info"]["email"])
      session[:user_id] = user.id
      session[:user_type] = TYPE_STUDENT
      redirect_to root_url, notice: "Logged in!"
    elsif Librarian.exists?(email: request.env["omniauth.auth"]["info"]["email"])
      user = Librarian.find_by_email(request.env["omniauth.auth"]["info"]["email"])
      if (user.is_approved == 0)
        flash.now[:alert] = "You have not been approved by the admin yet"
        render "new"
      else
        session[:user_id] = user.id
        session[:user_type] = TYPE_LIBRARIAN
        redirect_to root_url, notice: "Logged in!"
      end
    elsif Admin.exists?(email: request.env["omniauth.auth"]["info"]["email"])
      user = Admin.find_by_email(request.env["omniauth.auth"]["info"]["email"])
      session[:user_id] = user.id
      session[:user_type] = TYPE_ADMIN
      redirect_to root_url, notice: "Logged in!"
    else
      flash.now[:alert] = "Our system doesn't recognize that Email"
      render "new"
    end
  end
end
