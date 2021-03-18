class Admin < ApplicationRecord
  has_secure_password

  validates :email,
            :presence => true,
            :uniqueness => true,
            :format => {with: /\A([\w\d_\.-])+@(\w)+\.(\w)+\z/}
  validates :name,
            :presence => true
  validates :password,
            :presence => true,
            :format => {:with => /\A(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/,
                        :message => "must contain at least one lowercase alphabet, one uppercase alphabet, " +
                            "one digit and one special character"},
            :on => :create
end
