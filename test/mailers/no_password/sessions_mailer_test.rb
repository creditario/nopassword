# frozen_string_literal: true

require "test_helper"

module NoPassword
  class SessionsMailerTest < ActionMailer::TestCase
    test "it sends email with token" do
      session = no_password_sessions(:session_unclaimed)

      subject = SessionsMailer.with(session: session).send_token

      assert_emails 1 do
        subject.deliver_now
      end
    end
  end
end
