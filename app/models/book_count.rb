class BookCount < ApplicationRecord
  belongs_to :book
  belongs_to :library

  validates :book_id,
            :presence => true
  validates :library_id,
            :presence => true
  validates :book_copies,
            :presence => true,
            :numericality => {greater_than: 0},
            :on => :create

  def self.check_if_available?(book_id, library_id)
    book_count = BookCount.where(:book_id => book_id, :library_id => library_id).first
    if (book_count.book_copies > 0)
      return true
    else
      return false
    end
  end

  def self.book_count_decrement(book_id, library_id)
    book_count = BookCount.where(:book_id => book_id, :library_id => library_id).first
    book_count.update(:book_copies => book_count.book_copies - 1)
  end

  def self.book_count_increment(book_id, library_id)
    book_count = BookCount.where(:book_id => book_id, :library_id => library_id).first
    book_count.update(:book_copies => book_count.book_copies + 1)
  end
end
