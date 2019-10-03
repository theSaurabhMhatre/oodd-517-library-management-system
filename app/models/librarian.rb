class Librarian < ApplicationRecord
  has_secure_password

  belongs_to :university
  belongs_to :library

  validates :email,
            :presence => true,
            :uniqueness => true,
            :format => {with: /\A([\w\d_\.-])+@(\w)+\.(\w)+\z/}
  validates :name,
            :presence => true
  validates :password,
            :presence => true,
            :format => {:with => /\A(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/,
                        :message => "must contain at least one lowercase alphabet, one uppercase alphabet, one digit and one special character"},
            :on => :create
  # 0: not approved; 1: approved
  validates :is_approved,
            :presence => true,
            :inclusion => {in: [0, 1]},
            :on => :create
  validates :university_id,
            :presence => true
  validates :library_id,
            :presence => true

  def get_approved
    self[:is_approved] = 1
  end
end
