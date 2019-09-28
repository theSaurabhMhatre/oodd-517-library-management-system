class BookCount < ApplicationRecord
  belongs_to :book
  belongs_to :library

  validates :book_id,
            :presence => true
  validates :library_id,
            :presence => true
  validates :count,
            :presence => true,
            :numericality => {greater_than: 0}

  def self.check_if_available(book_id)
    library_ids = Library.where(:university_id => student.university_id).map {|x| x.id }
    book_count = BookCount.where(:book_id => book_id, :library_id => library_ids).map {|x| x.count}
    puts ""
  end
end
