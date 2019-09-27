class Student < ApplicationRecord
  UNDERGRADUATE = "undergraduate"
  GRADUATE = "graduate"
  PHD_STUDENT = "phd_student"

  has_many :book_requests
  has_many :book_histories
  belongs_to :university

  validates :email,
            :presence => true,
            :uniqueness => true,
            :format => {with: /\A([\w\d_\.])+@(\w)+\.(\w)+\z/}
  validates :name,
            :presence => true
  validates :password,
            :presence => true
  validates :edu_level,
            :presence => true,
            :inclusion => {in: [UNDERGRADUATE, GRADUATE, PHD_STUDENT]}
  validates :book_limit,
            :presence => true,
            :numericality => {greater_than: 0}
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
end
