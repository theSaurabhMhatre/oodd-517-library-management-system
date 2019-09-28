class Admin < ApplicationRecord
  has_secure_password

  validates :email,
            :presence => true,
            :uniqueness => true,
            :format => {with: /\A([\w\d_\.])+@(\w)+\.(\w)+\z/}
  validates :name,
            :presence => true
end
