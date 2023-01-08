class User < ApplicationRecord
  has_secure_password

  has_many :orders

  has_many :addresses
  accepts_nested_attributes_for :addresses, allow_destroy: true

  has_many :cards

  before_save :downcase_email


  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }

  before_create :make_first_admin

  has_many :blogs
  has_many :comments

  has_one :conversation

  has_many :orders

  def confrim!
    update_columns(confirmed_at: Time.current)
  end

  def confirmed?
    confirmed_at.present?
  end

  def send_confirmation_email!
    WelcomeMailer.with(user: self).welcome.deliver_now
  end

  private

  def make_first_admin
    User.first == nil ? self.admin = true : self.admin = false
  end

  def downcase_email
    self.email = email.downcase
  end
end
