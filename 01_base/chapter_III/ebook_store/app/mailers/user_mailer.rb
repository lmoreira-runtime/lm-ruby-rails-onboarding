# frozen_string_literal: true

# Mailer to handle user-related emails.
class UserMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to Runtime's Ebook Store")
  end

  def ebook_bought_email
    @user = params[:user]
    @ebook = params[:ebook]
    @fee = params[:fee]
    mail(to: @user.email, subject: 'Your Earnings from eBook Sale')
  end

  def ebook_statistics_email
    @user = params[:user]
    @ebook = params[:ebook]
    mail(to: @user.email, subject: 'Detailed Statistics for Your eBook')
  end
end
