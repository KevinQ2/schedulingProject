class User < ApplicationRecord
  has_many :organization_members, dependent: :destroy

  require 'bcrypt'
  has_secure_password

  before_validation {
    self.username.downcase!
    self.email.downcase!
  }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_TELEPHONE_REGEX = /\A[0-9]+\z/i

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 4, maximum: 30}
  validates :first_name, presence: true, length: { minimum: 2, maximum: 20}
  validates :last_name, presence: true, length: { minimum: 2, maximum: 20}
  validates :email, allow_blank: true, format: { with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false}
  validates :telephone, allow_blank: true, format: { with: VALID_TELEPHONE_REGEX}, uniqueness: {case_sensitive: false}

end
