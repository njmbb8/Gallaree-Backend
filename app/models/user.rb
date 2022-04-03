class User < ApplicationRecord
  has_secure_password

  has_many :orders

  has_many :addresses
  accepts_nested_attributes_for :addresses, allow_destroy: true



  before_save :downcase_email

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }

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

  def downcase_email
    self.email = email.downcase
  end
end
