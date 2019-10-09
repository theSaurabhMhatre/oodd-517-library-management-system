class Library < ApplicationRecord
  has_many :librarians,
           :dependent => :delete_all
  has_many :book_counts,
           :dependent => :delete_all
  has_many :book_requests,
           :dependent => :delete_all
  has_many :book_histories,
           :dependent => :delete_all
  belongs_to :university

  validates :name,
            :presence => true
  validates :location,
            :presence => true
  validates :max_days,
            :presence => true,
            :numericality => {greater_than: 0}
  validates :overdue_fine,
            :presence => true,
            :numericality => {greater_than: 0}
  validates :university_id,
            :presence => true

  def self.check_if_authorised?(user_type, user_id, library_id);
    case user_type
    when ApplicationController::TYPE_STUDENT
      libraries = Library.where(:university_id => Student.find(user_id).university_id).collect{|x| x.id};
      return libraries.include?(library_id.to_i);
    when ApplicationController::TYPE_LIBRARIAN
      return Librarian.find(user_id).library_id == library_id.to_i
    end
  end

  def self.delete(library_id)
    # increment student book limits
    BookHistory.increment_student_limits_by_books_issued_by_library(library_id)
    Library.destroy(library_id)
  end
end
