class Book < ApplicationRecord
  IS_SPECIAL = "yes"
  IS_NOT_SPECIAL = "no"

  has_many :book_counts
  has_many :book_requests
  has_many :book_histories

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
end
