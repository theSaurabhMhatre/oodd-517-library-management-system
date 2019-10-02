class Book < ApplicationRecord
  IS_SPECIAL = "yes"
  IS_NOT_SPECIAL = "no"

  has_many :book_counts,
           :dependent => :delete_all
  has_many :book_requests,
           :dependent => :delete_all
  has_many :book_histories,
           :dependent => :delete_all

  validates :isbn,
            :presence => true,
            :uniqueness => true
  validates :title,
            :presence => true
  validates :author,
            :presence => true
  validates :language,
            :presence => true
  validates :published,
            :presence => true,
            :date => {before: Proc.new { Time.now }}
  validates :edition,
            :presence => true
  validates :image,
            :presence => true
  validates :subject,
            :presence => true
  validates :summary,
            :presence => true
  validates :is_special,
            :presence => true,
            :inclusion => {in: [IS_SPECIAL, IS_NOT_SPECIAL]}

  def self.fetch_books(library_id)
    if (library_id.nil?)
      books = Book.all;
    else
      book_ids = BookCount.where(:library_id => library_id).map { |x| x.book_id };
      books = Book.find(book_ids)
    end
    return books
  end

  def self.filter_books(library_id, book_title, book_author)
    if (library_id.nil?)
      books = Book.where("title like :title and author like :author",
                         :title => "%#{book_title}%",
                         :author => "%#{book_author}%")
    else
      book_ids = BookCount.where(:library_id => library_id).map { |x| x.book_id };
      books = Book.where("id in (:book_ids) and title like :title and author like :author",
                         :book_ids => book_ids,
                         :title => "%#{book_title}%",
                         :author => "%#{book_author}%")
    end
    return books;
  end

  def self.check_if_in_use(book_id)
    if (BookHistory.check_if_book_in_use?(book_id) or
        BookRequest.check_if_book_in_use?(book_id) or
        BookCount.check_if_book_in_use?(book_id))
      return false
    else
      return true
    end
  end
end
