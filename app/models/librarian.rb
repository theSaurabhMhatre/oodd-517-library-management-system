class Librarian < ApplicationRecord
  belongs_to :library

  validates :email,
            :presence => true,
            :uniqueness => true
  validates :name,
            :presence => true
  validates :password,
            :presence => true
  # 0: not approved; 1: approved
  validates :is_approved,
            :presence => true,
            :inclusion => {in: [0,1]}
  validates :library_id,
            :presence => true
end
