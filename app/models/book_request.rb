class BookRequest < ApplicationRecord
  IS_BOOKMARK = "bookmark"
  IS_SPECIAL = "special"
  IS_NORMAL = "normal"

  belongs_to :book
  belongs_to :library
  belongs_to :student

  validates :book_id,
            :presence => true
  validates :library_id,
            :presence => true
  validates :student_id,
            :presence => true
  validates :type,
            :presence => true,
            :inclusion => {in: [IS_BOOKMARK, IS_SPECIAL, IS_NORMAL]}
end
