require "application_system_test_case"

class BookCountsTest < ApplicationSystemTestCase
  setup do
    @book_count = book_counts(:one)
  end

  test "visiting the index" do
    visit book_counts_url
    assert_selector "h1", text: "Book Counts"
  end

  test "creating a Book count" do
    visit book_counts_url
    click_on "New Book Count"

    fill_in "Book", with: @book_count.book_id
    fill_in "Count", with: @book_count.count
    fill_in "Library", with: @book_count.library_id
    click_on "Create Book count"

    assert_text "Book count was successfully created"
    click_on "Back"
  end

  test "updating a Book count" do
    visit book_counts_url
    click_on "Edit", match: :first

    fill_in "Book", with: @book_count.book_id
    fill_in "Count", with: @book_count.count
    fill_in "Library", with: @book_count.library_id
    click_on "Update Book count"

    assert_text "Book count was successfully updated"
    click_on "Back"
  end

  test "destroying a Book count" do
    visit book_counts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Book count was successfully destroyed"
  end
end
