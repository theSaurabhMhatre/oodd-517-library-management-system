class Librarian < ApplicationRecord
  belongs_to :university
  belongs_to :library

  validates :email,
            :presence => true,
            :uniqueness => true,
            :format => {with: /\A([\w\d_\.])+@(\w)+\.(\w)+\z/}
  validates :name,
            :presence => true
  validates :password,
            :presence => true
  # 0: not approved; 1: approved
  validates :is_approved,
            :presence => true,
            :inclusion => {in: [0,1]}
  validates :university_id,
            :presence => true
  validates :library_id,
            :presence => true
end
