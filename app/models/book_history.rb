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
end
