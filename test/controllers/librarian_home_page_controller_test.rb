require 'test_helper'

class LibrarianHomePageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get librarian_home_page_index_url
    assert_response :success
  end

end
