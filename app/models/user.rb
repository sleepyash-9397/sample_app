class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true,
                   length: {maximum: Settings.length.max_name}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    length: {maximum: Settings.length.max_email},
                    format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  has_secure_password
  validates :password, presence: true,
                       length: {minimum: Settings.length.min_pass}

  private

  def downcase_email
    self.email = email.downcase!
  end
end
