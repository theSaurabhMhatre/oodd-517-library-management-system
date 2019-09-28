require 'test_helper'

class StudentHomePageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get student_home_page_index_url
    assert_response :success
  end

end
