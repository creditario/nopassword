# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/sessions_mailer
class SessionsMailerPreview < ActionMailer::Preview
  def send_token
    current_session = NoPassword::SessionManager.new.create("Preview", "test@mail.com", "127.0.0.1")

    NoPassword::SessionsMailer.with(session: current_session).send_token
  end
end
