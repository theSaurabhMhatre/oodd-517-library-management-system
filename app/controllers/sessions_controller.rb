class SessionsController < ApplicationController
  def new
    if session[:user_id]!= nil
      redirect_to root_url
    end
  end

  def create
    show_not_approved_flash = false;
    case params[:user_type]
    when TYPE_STUDENT
      user = Student.find_by_email(params[:email])
    when TYPE_LIBRARIAN
      user = Librarian.find_by_email(params[:email])
      if(user.is_approved == 0)
        user = nil
        show_not_approved_flash = true;
      end
    when TYPE_ADMIN
      user = Admin.find_by_email(params[:email])
    end
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:user_type] = params[:user_type]
      redirect_to root_url, notice: "Logged in!"
    else
      if(params[:user_type] == TYPE_LIBRARIAN and show_not_approved_flash)
        flash.now[:alert] = "You have not been approved by the admin yet"
      else
        flash.now[:alert] = "Email or password is invalid"
      end
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
