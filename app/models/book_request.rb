class BookRequest < ApplicationRecord
  IS_BOOKMARK = "bookmark"
  IS_SPECIAL = "special"
  IS_NORMAL = "normal"
  IS_HOLD = "hold"

  belongs_to :book
  belongs_to :library
  belongs_to :student

  validates :book_id,
            :presence => true
  validates :library_id,
            :presence => true
  validates :student_id,
            :presence => true
  validates :request_type,
            :presence => true,
            :inclusion => {in: [IS_BOOKMARK, IS_SPECIAL, IS_NORMAL, IS_HOLD]}

  def self.bookmark_book(user_id, book_id, library_id)
    count = BookRequest.where(:book_id => book_id, :library_id => library_id, :student_id => user_id, :request_type => IS_BOOKMARK).count
    if(count == 0)
      BookRequest.create(:book_id => book_id, :library_id => library_id, :student_id => user_id, :request_type => IS_BOOKMARK)
      return 1
    else
      return 0
    end
  end

  # 0: book_limit reached
  # 1: special book request, pending with admin
  # 2: normal book request, issued to user
  # 3: book unavailable
  # 4: already checked out
  def self.checkout_book(user_id, book_id, library_id)
    check = Student.can_borrow(user_id)
    if(check == false)
      return 0
    end
    check = BookCount.check_if_available?(book_id, library_id)
    if(check)
      checked_out = BookHistory.where(:book_id => book_id, :library_id => library_id, :student_id => user_id).count
      req_pending = BookRequest.where(:book_id => book_id, :library_id => library_id, :student_id => user_id).count
      if(checked_out > 0 or req_pending > 0)
        return 4
      end
      if(Book.find(book_id).is_special == Book::IS_SPECIAL)
        # TODO: decrement book count and book limit if admin approves
        BookRequest.create(:book_id => book_id, :library_id => library_id, :student_id => user_id, :request_type => IS_SPECIAL)
        return 1
      else
        # assigning the book to the user
        BookHistory.issue_book(book_id, library_id, user_id)
        # decrementing the book count and book limit
        BookCount.book_count_decrement(book_id, library_id)
        Student.decrement_book_limit(user_id)
        # TODO: send mail to user
        return 2
      end
    else
      count = BookRequest.where(:book_id => book_id, :library_id => library_id, :student_id => user_id, :request_type => IS_HOLD).count
      if(count == 0)
        BookRequest.create(:book_id => book_id, :library_id => library_id, :student_id => user_id, :request_type => IS_HOLD)
      end
      return 3
    end
  end
end
