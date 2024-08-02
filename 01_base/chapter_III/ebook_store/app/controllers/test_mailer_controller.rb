# frozen_string_literal: true

# Controller to handle test mailer actions.
class TestMailerController < ApplicationController
  def index
    ebook = Ebook.first
    user = User.first
    UserMailer.with(ebook:, user:).welcome_email.deliver_now
    render plain: 'Email sent'
  end
end
