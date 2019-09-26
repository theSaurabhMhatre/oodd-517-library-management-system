class Student < ApplicationRecord
  UNDERGRADUATE = "undergraduate"
  GRADUATE = "graduate"
  PHD_STUDENT = "phd_student"

  has_many :book_requests
  has_many :book_histories
  belongs_to :university

  validates :email,
            :presence => true,
            :uniqueness => true
  validates :name,
            :presence => true
  validates :password,
            :presence => true
  validates :edu_level,
            :presence => true,
            :inclusion => {in: [UNDERGRADUATE, GRADUATE,PHD_STUDENT]}
  validates :book_limit,
            :presence => true,
            :numericality => {greater_than: 0}
  validates :university_id,
            :presence => true
end
