class Student < ApplicationRecord
  has_secure_password

  UNDERGRADUATE = "undergraduate"
  GRADUATE = "graduate"
  PHD_STUDENT = "phd_student"

  has_many :book_requests
  has_many :book_histories
  belongs_to :university

  validates :email,
            :presence => true,
            :uniqueness => true,
            :format => {with: /\A([\w\d_\.-])+@(\w)+\.(\w)+\z/}
  validates :name,
            :presence => true
  validates :password,
            :presence => true,
            :format => {:with => /\A(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/,
                        :message => "must contain at least one lowercase alphabet, one uppercase alphabet, one digit and one special character and the minimum length should be 8 characters"},
            :on => :create
  validates :edu_level,
            :presence => true,
            :inclusion => {in: [UNDERGRADUATE, GRADUATE, PHD_STUDENT]}
  validates :book_limit,
            :presence => true,
            :numericality => {greater_than: 0},
            :on => :create
  validates :university_id,
            :presence => true

  def set_book_limit
    case self.edu_level
    when UNDERGRADUATE
      self.book_limit = 2
    when GRADUATE
      self.book_limit = 4
    when PHD_STUDENT
      self.book_limit = 6
    end
  end

  def self.can_borrow(student_id)
    student = Student.find(student_id)
    if (student.book_limit > 0)
      return true
    else
      return false
    end
  end

  def self.decrement_book_limit(student_id)
    student = Student.find(student_id)
    student.update(:book_limit => student.book_limit - 1)
  end

  def self.increment_book_limit(student_id)
    student = Student.find(student_id)
    student.update(:book_limit => student.book_limit + 1)
  end
end
