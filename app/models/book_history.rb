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
end
