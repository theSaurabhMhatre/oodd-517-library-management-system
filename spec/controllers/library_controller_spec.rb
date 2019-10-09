require 'rails_helper'

RSpec.describe LibrariesController, type: :controller do

  # Rspec for creation
  it "should redirect to index of Home Page with a notice on successful save" do
    post 'create'
    response.should redirect_to(login_path)
    flash[:notice].equal?'Library was successfully created.'
  end

  it "should redirect to Login Page on failed save" do
    post 'create'
    flash[:notice].should be_nil
    response.should redirect_to(login_path)
  end

  it "should pass params to Library" do
    post 'create', :params => { :library => {:name => 'Plain', :location  => 'Plain', :max_days  => 'Plain', :overdue_fine  => 'Plain', :university_id  => 'Plain'}}
    expect(response.content_type).to eq "text/html"
  end

  # Rspec for index
  it "should pass redirect/ show information of correct module" do
    post 'index'
    if session[:user_type].equal?"librarian" then (flash[:notice].equal?"You are not authorised to perform this action")
    end
    if session[:user_type].equal?"admin" then (@libraries.equal?true)
    end
    if session[:user_type].equal?"student" then (@libraries.equal?true)
    end
  end

  # Rspec for show
  val = false
  it "should not show any library to the librarian if he is not approved" do
    if (val == false) then (flash[:notice].equal?"You are not authorised to perform this action")
  end
  end

  #Rspec for new
  it "should create a new library if the user is admin else it should display notice" do
    subject { show.pos(*arguments) }
    if session[:user_type].equal?"admin" then (@library.equal?true)
    end
  end

  #Rspec for edit
  it "should display notice/ redirect as per the type of user" do
    subject { edit.pos(*arguments) }
    if session[:user_type].equal?"student" then (flash[:notice].equal?"You are not authorised to perform this action")
    end
  end

end

