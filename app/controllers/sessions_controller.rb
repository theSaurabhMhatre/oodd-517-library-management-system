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
    if session[:google_signup_user_type] == '3'
      if Student.exists?(email: request.env["omniauth.auth"]["info"]["email"])
        user = Student.find_by_email(request.env["omniauth.auth"]["info"]["email"])
        session[:user_id] = user.id
        session[:user_type] = TYPE_STUDENT
        redirect_to root_url, notice: "Logged in!"
      else
        redirect_to new_student_url(:name => request.env["omniauth.auth"]["info"]["name"], :email => request.env["omniauth.auth"]["info"]["email"], :without_password => 1), notice: "You dont have a student account. Please sign up."
      end
    elsif session[:google_signup_user_type] == '4'
      if Librarian.exists?(email: request.env["omniauth.auth"]["info"]["email"])
        user = Librarian.find_by_email(request.env["omniauth.auth"]["info"]["email"])
        if (user.is_approved == 0)
          flash.now[:alert] = "You have not been approved by the admin yet"
          render "new"
        else
          session[:user_id] = user.id
          session[:user_type] = TYPE_LIBRARIAN
          redirect_to root_url, notice: "Logged in!"
        end
      else
        redirect_to new_librarian_url(:name => request.env["omniauth.auth"]["info"]["name"], :email => request.env["omniauth.auth"]["info"]["email"], :without_password => 1), notice: "You dont have a librarian account. Please sign up."
      end
    elsif session[:google_signup_user_type] == '1'
      if Student.exists?(email: request.env["omniauth.auth"]["info"]["email"])
        user = Student.find_by_email(request.env["omniauth.auth"]["info"]["email"])
        session[:user_id] = user.id
        session[:user_type] = TYPE_STUDENT
        redirect_to root_url, notice: "You have already signed up!"
      else
        redirect_to new_student_url(:name => request.env["omniauth.auth"]["info"]["name"], :email => request.env["omniauth.auth"]["info"]["email"])
      end
    elsif session[:google_signup_user_type] == '2'
      if Librarian.exists?(email: request.env["omniauth.auth"]["info"]["email"])
        user = Librarian.find_by_email(request.env["omniauth.auth"]["info"]["email"])
        if (user.is_approved == 0)
          flash.now[:alert] = "You have already signed up and are waiting for admin approval"
          render "new"
        else
          session[:user_id] = user.id
          session[:user_type] = TYPE_LIBRARIAN
          redirect_to root_url, notice: "You have already signed up!"
        end
      else
        redirect_to new_librarian_url(:name => request.env["omniauth.auth"]["info"]["name"], :email => request.env["omniauth.auth"]["info"]["email"])
      end
    else
      render "new"
    end
    # if Student.exists?(email: request.env["omniauth.auth"]["info"]["email"])
    #   if session[:google_signup_user_type] == '1' or session[:google_signup_user_type]==nil
    #     user = Student.find_by_email(request.env["omniauth.auth"]["info"]["email"])
    #     session[:user_id] = user.id
    #     session[:user_type] = TYPE_STUDENT
    #     if session[:google_signup_user_type]==nil
    #       redirect_to root_url, notice: "You already have an account!"
    #     else
    #       redirect_to root_url, notice: "Logged in!"
    #   else
    #     redirect_to new_librarian_url, notice: "Students cannot create a Librarian account"
    #
    # elsif Librarian.exists?(email: request.env["omniauth.auth"]["info"]["email"])
    #   user = Librarian.find_by_email(request.env["omniauth.auth"]["info"]["email"])
    #   if (user.is_approved == 0)
    #     flash.now[:alert] = "You have not been approved by the admin yet"
    #     render "new"
    #   else
    #     session[:user_id] = user.id
    #     session[:user_type] = TYPE_LIBRARIAN
    #     redirect_to root_url, notice: "Logged in!"
    #   end
    # elsif Admin.exists?(email: request.env["omniauth.auth"]["info"]["email"])
    #   user = Admin.find_by_email(request.env["omniauth.auth"]["info"]["email"])
    #   session[:user_id] = user.id
    #   session[:user_type] = TYPE_ADMIN
    #   redirect_to root_url, notice: "Logged in!"
    # elsif session[:google_signup_user_type] == '1'
    #   redirect_to new_student_url(:name => request.env["omniauth.auth"]["info"]["name"], :email => request.env["omniauth.auth"]["info"]["email"], :without_password => 1)
    # elsif session[:google_signup_user_type] == '2'
    #   redirect_to new_librarian_url(:name => request.env["omniauth.auth"]["info"]["name"], :email => request.env["omniauth.auth"]["info"]["email"], :without_password => 1)
    # else
    #     flash.now[:alert] = "Our system does not recognize your Google account. Try signing up."
    #     render "new"
    # end
  end

  def set_google_signup_user_type
    session[:google_signup_user_type] = params[:google_signup_user_type]
    redirect_to("/auth/google_oauth2")
  end
end
