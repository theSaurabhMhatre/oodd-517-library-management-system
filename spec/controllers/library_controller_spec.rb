require 'rails_helper'

RSpec.describe LibraryController, type: :controller do
  integrate_views
  fixtures :libraries

  it "should redirect to index with a notice on successful save" do
    Library.any_instance.stubs(:valid?).returns(true)
    post 'create'
    flash[:notice].should_not be_nil
    response.should redirect_to(libraries_path)


  end
end
