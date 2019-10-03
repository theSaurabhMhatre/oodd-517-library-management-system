class BookHistory < ApplicationRecord
  ISSUED = "issued"
  RETURNED = "returned"

  belongs_to :book
  belongs_to :library
  belongs_to :student

  validates :book_id,
            :presence => true
  validates :library_id,
            :presence => true
  validates :student_id,
            :presence => true
  validates :action,
            :presence => true,
            :inclusion => {in: [ISSUED, RETURNED]}

  def self.issue_book(book_id, library_id, user_id)
    BookHistory.create(:book_id => book_id, :library_id => library_id, :student_id => user_id, :action => ISSUED)
  end

  def self.return_book(book_id, library_id, user_id)
    book = BookHistory.where(:book_id => book_id, :library_id => library_id, :student_id => user_id, :action => ISSUED)
    book.update(:action => RETURNED);
  end

  def self.fetch_checked_out_books(user_id, request_type)
    book_history = BookHistory.where(:student_id => user_id, :action => request_type)
    return book_history
  end

  def self.check_if_book_in_use?(book_id)
    count = BookHistory.where(:book_id => book_id, :action => BookHistory::ISSUED).count
    if count > 0
      return true
    else
      return false
    end
  end

  def self.overdue_detail_for_libraries(library_ids, *args)
    overdue_details = []
    libraries = Library.where(:id => library_ids)
    libraries.each do |library|
      if(args.length > 0)
        overdue_books = BookHistory.where("student_id = :student_id and library_id = :library_id and created_at < :max_days and action = 'issued'",
                                          :student_id => args[0],
                                          :library_id => library.id,
                                          :max_days => (Time.now - library.max_days * 86400))
      else
        overdue_books = BookHistory.where("library_id = :library_id and created_at < :max_days and action = 'issued'",
                                          :library_id => library.id,
                                          :max_days => (Time.now - library.max_days * 86400))
      end
      overdue_books.each do |book|
        overdue_detail = []
        overdue_detail.push(library.name)
        overdue_detail.push(Book.find(book.book_id).title)
        overdue_detail.push((((Time.now - book.created_at)/86400) - library.max_days).floor)
        overdue_detail.push((overdue_detail[2])*library.overdue_fine)
        if(args.length == 0)
          overdue_detail.push(Student.find(book.student_id).name)
        end
        overdue_details.push(overdue_detail)
      end
    end
    return overdue_details
  end

  def self.overdue_books_for_student(student_id)
    library_ids = BookHistory.where(:student_id => student_id, :action => BookHistory::ISSUED)
                      .map {|x| x.library_id}.uniq
    overdue_details = BookHistory.overdue_detail_for_libraries(library_ids, student_id)
    return overdue_details
  end

  def self.overdue_books_for_library(library_id)
    overdue_details = BookHistory.overdue_detail_for_libraries(library_id)
    return overdue_details
  end

  def self.overdue_books_for_system
    library_ids = Library.all.map{|x| x.id}
    overdue_details = BookHistory.overdue_detail_for_libraries(library_ids)
    return overdue_details
  end
end
