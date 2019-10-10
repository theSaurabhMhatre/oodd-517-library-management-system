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
    if (count == 0)
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
  # 5: book on hold
  def self.checkout_book(user_id, book_id, library_id)
    # check if book is already checked out
    checked_out = BookHistory.where(:book_id => book_id, :library_id => library_id, :student_id => user_id, :action => BookHistory::ISSUED).count
    if (checked_out > 0)
      return 4
    end
    # check if the student has exceeded the max number of books which can be borrowed
    check = Student.can_borrow(user_id)
    if (check == false)
      return 0
    end
    # check if the book to be checked out is available
    check = BookCount.check_if_available?(book_id, library_id)
    if (check)
      # check if the book is special
      if (Book.find(book_id).is_special == Book::IS_SPECIAL)
        check = BookRequest.exists?(:book_id => book_id, :library_id => library_id, :student_id => user_id, :request_type => IS_SPECIAL)
        if(check == false)
          BookRequest.create(:book_id => book_id, :library_id => library_id, :student_id => user_id, :request_type => IS_SPECIAL)
        end
        # if the book was on hold, remove it from the hold list
        # this will happen when completing hold requests
        on_hold = BookRequest.where(:book_id => book_id, :library_id => library_id, :student_id => user_id, :request_type => BookRequest::IS_HOLD).count
        if (on_hold > 0)
          book_request = BookRequest.where(:book_id => book_id, :library_id => library_id, :student_id => user_id, :request_type => BookRequest::IS_HOLD)
          book_request[0].destroy
        end
        return 1
      else
        # assigning the book to the user
        BookHistory.issue_book(book_id, library_id, user_id)
        # decrementing the book count and book limit
        BookCount.book_count_decrement(book_id, library_id)
        Student.decrement_book_limit(user_id)
        LibraryMailer.with(:student => Student.find(user_id)).success_mail.deliver_now
        # if the book was on hold, remove it from the hold list
        on_hold = BookRequest.where(:book_id => book_id, :library_id => library_id, :student_id => user_id, :request_type => BookRequest::IS_HOLD).count
        if (on_hold > 0)
          book_request = BookRequest.where(:book_id => book_id, :library_id => library_id, :student_id => user_id, :request_type => BookRequest::IS_HOLD)
          book_request[0].destroy
        end
        return 2
      end
    else
      # book to be checked out is unavailable
      check = BookRequest.exists?(:book_id => book_id, :library_id => library_id, :student_id => user_id, :request_type => IS_HOLD)
      if (check == false)
        BookRequest.create(:book_id => book_id, :library_id => library_id, :student_id => user_id, :request_type => IS_HOLD)
      else
        return 5
      end
      return 3
    end
  end

  def self.complete_hold_request(book_id, library_id)
    # TODO: add check in case the book is special
    book_requests = BookRequest.where(:book_id => book_id, :library_id => library_id, :request_type => BookRequest::IS_HOLD).order(:created_at)
    for book_request in book_requests
      check = BookRequest.checkout_book(book_request.student_id, book_request.book_id, book_request.library_id)
      if(check == 2)
        # TODO: change mail template
        LibraryMailer.with(:student => Student.find(user_id)).success_mail.deliver_now
        break
      end
    end
  end

  def self.check_hold(book_id, library_id)
    hold_count = BookRequest.where(:book_id => book_id, :library_id => library_id).count
    if (hold_count > 0)
      BookRequest.complete_hold_request(book_id, library_id)
    end
  end

  def self.fetch_student_requests(student_id, request_type)
    book_requests = BookRequest.where(:student_id => student_id, :request_type => request_type)
    return book_requests
  end

  def self.check_if_book_in_use?(book_id)
    count = BookRequest.where(:book_id => book_id).count
    if count > 0
      return true
    else
      return false
    end
  end

  # 1: approved
  # 0: book unavailable
  # 2: student book limit reached, cannot approve now
  def self.approve_special_request(book_request)
    if Student.can_borrow(book_request.student_id) == false
      return 2
    end
    if BookCount.check_if_available?(book_request.book_id, book_request.library_id)
      BookRequest.destroy(book_request.id)
      BookHistory.issue_book(book_request.book_id, book_request.library_id, book_request.student_id)
      BookCount.book_count_decrement(book_request.book_id, book_request.library_id)
      Student.decrement_book_limit(book_request.student_id)
      LibraryMailer.with(:student => Student.find(book_request.student_id)).success_mail.deliver_now
      return 1
    else
      return 0
    end
  end

  def self.reject_special_request(book_request)
    BookRequest.destroy(book_request.id)
  end

  def self.fetch_requests_by_librarian(user_id)
    library_id = Librarian.find(user_id).library_id
    book_requests = BookRequest.where(:library_id => library_id, :request_type => [BookRequest::IS_SPECIAL, BookRequest::IS_HOLD])
    return book_requests
  end

  def self.fetch_special_and_hold_requests
    book_requests = BookRequest.where(:request_type => BookRequest::IS_HOLD)
                        .or(BookRequest.where(:request_type => BookRequest::IS_SPECIAL))
    return book_requests
  end

  def self.check_if_authorised?(user_type, object_id, book_request_id)
    case user_type
    when ApplicationController::TYPE_STUDENT
      count = BookRequest.where(:student_id => object_id, :id => book_request_id).count
    when ApplicationController::TYPE_LIBRARIAN
      count = BookRequest.where(:library_id => object_id, :id => book_request_id, :request_type => BookRequest::IS_SPECIAL)
                  .or(BookRequest.where(:library_id => object_id, :id => book_request_id, :request_type => BookRequest::IS_HOLD)).count
    end
    if(count > 0)
      return true
    else
      return false
    end
  end
end
