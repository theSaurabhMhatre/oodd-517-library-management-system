require 'test_helper'

class BookCountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book_count = book_counts(:one)
  end

  test "should get index" do
    get book_counts_url
    assert_response :success
  end

  test "should get new" do
    get new_book_count_url
    assert_response :success
  end

  test "should create book_count" do
    assert_difference('BookCount.count') do
      post book_counts_url, params: { book_count: { book_id: @book_count.book_id, book_copies: @book_count.book_copies, library_id: @book_count.library_id } }
    end

    assert_redirected_to book_count_url(BookCount.last)
  end

  test "should show book_count" do
    get book_count_url(@book_count)
    assert_response :success
  end

  test "should get edit" do
    get edit_book_count_url(@book_count)
    assert_response :success
  end

  test "should update book_count" do
    patch book_count_url(@book_count), params: { book_count: { book_id: @book_count.book_id, book_copies: @book_count.book_copies, library_id: @book_count.library_id } }
    assert_redirected_to book_count_url(@book_count)
  end

  test "should destroy book_count" do
    assert_difference('BookCount.count', -1) do
      delete book_count_url(@book_count)
    end

    assert_redirected_to book_counts_url
  end
end
