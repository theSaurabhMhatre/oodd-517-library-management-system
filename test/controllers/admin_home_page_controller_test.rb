require 'test_helper'

class AdminHomePageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_home_page_index_url
    assert_response :success
  end

end
