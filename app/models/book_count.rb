class BookCount < ApplicationRecord
  belongs_to :book
  belongs_to :library

  validates :book_id,
            :presence => true
  validates :library_id,
            :presence => true
  validates :count,
            :presence => true
end
