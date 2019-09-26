class Library < ApplicationRecord
  has_one :librarian
  has_many :book_counts
  has_many :book_requests
  has_many :book_histories
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
end
