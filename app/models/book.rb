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

  def self.filter_books(params)
    library_id = params[:library_id]
    book_title = params[:book_title].nil? ? "" : params[:book_title]
    book_subject = params[:book_subject].nil? ? "" : params[:book_subject]
    pub_date_start = params[:pub_date_start].empty? ? Time.local(1970, 1, 1) : params[:pub_date_start]
    pub_date_end = params[:pub_date_end].empty? ? Time.now : params[:pub_date_end]
    book_author = params[:book_author].nil? ? "" : params[:book_author]
    check = Book.dates_valid?(pub_date_start, pub_date_end)
    if(check == false)
      return nil
    end
    if (library_id.nil? || library_id.empty?)
      books = Book.where("lower(title) like :title and lower(author) like :author and lower(subject) like :subject and published >= :start and published <= :end",
                         :title => "%#{book_title.downcase}%",
                         :author => "%#{book_author.downcase}%",
                         :subject => "%#{book_subject.downcase}%",
                         :start => pub_date_start,
                         :end => pub_date_end)
    else
      book_ids = BookCount.where(:library_id => library_id).map { |x| x.book_id };
      books = Book.where("id in (:book_ids) and lower(title) like :title and lower(author) like :author and lower(subject) like :subject and published >= :start and published <= :end",
                         :book_ids => book_ids,
                         :title => "%#{book_title.downcase}%",
                         :author => "%#{book_author.downcase}%",
                         :subject => "%#{book_subject.downcase}%",
                         :start => pub_date_start,
                         :end => pub_date_end)
    end
    return books;
  end

  def self.delete(book_id)
    # increment student book_limits
    BookHistory.increment_student_limits_by_book_issued(book_id)
    Book.destroy(book_id)
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

  def self.dates_valid?(pub_date_start, pub_date_end)
    start_date = Date.parse(pub_date_start.to_s)
    end_date = Date.parse(pub_date_end.to_s)
    if start_date > end_date
      return false
    else
      return true
    end
  end
end
