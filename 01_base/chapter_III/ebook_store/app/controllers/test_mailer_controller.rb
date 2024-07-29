class TestMailerController < ApplicationController
  def index
    ebook = Ebook.first
    user = User.first
    UserMailer.with(ebook: ebook, user: user).welcome_email.deliver_now
    render plain: "Email sent"
  end
end