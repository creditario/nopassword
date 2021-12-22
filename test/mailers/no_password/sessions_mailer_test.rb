# typed: ignore
# frozen_string_literal: true

require "test_helper"

module NoPassword
  class SessionsMailerTest < ActionMailer::TestCase
    test "it sends a token to a valid email" do
      session = no_password_sessions(:session_one)
      session.update(token: "8383833")

      subject = SessionsMailer.with(session: session).send_token

      assert_emails 1 do
        subject.deliver_now
      end
    end

    test "it can't send an email to a nil email address" do
      session = no_password_sessions(:session_one)
      session.update(email: nil)

      SessionsMailer.with(session: session).send_token

      assert_no_emails
    end
  end
end
