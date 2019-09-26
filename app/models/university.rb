class University < ApplicationRecord
  has_many :libraries
  has_many :students

  validates :name,
            :presence => true
  validates :city,
            :presence => true
  validates :state,
            :presence => true
end
