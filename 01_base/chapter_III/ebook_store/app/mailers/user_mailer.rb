class UserMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def welcome_email
    @user = params[:user]
    @ebook = params[:ebook]
    @url  = 'http://localhost:3000/'
    mail(to: @user.email, subject: 'Welcome to Our Awesome Site')
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
