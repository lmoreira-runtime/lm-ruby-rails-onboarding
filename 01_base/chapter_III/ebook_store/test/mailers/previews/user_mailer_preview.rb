# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    ebook = Ebook.first
    user = User.first
    UserMailer.with(ebook:, user:).welcome_email
  end
end
