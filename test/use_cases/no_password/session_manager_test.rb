require "test_helper"

module NoPassword
  class SessionManagerTest < ActiveSupport::TestCase
    REMOTE_ADDR = "127.0.0.1"
    USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Safari/605.1.15"

    test "it creates a new session" do
      email = "user@example.com"

      subject = NoPassword::SessionManager.new
      assert_difference "NoPassword::Session.count" do
        session = subject.create(USER_AGENT, email, REMOTE_ADDR)

        refute_nil session
        assert_nil session.claimed_at
        refute_nil session.token
      end
    end

    test "it expires previous unclaimed session and creates a new one" do
      unclaimed_session = no_password_sessions(:session_unclaimed)

      subject = NoPassword::SessionManager.new

      assert_difference "NoPassword::Session.count" do
        subject.create(USER_AGENT, unclaimed_session.email, REMOTE_ADDR)
      end

      unclaimed_session.reload
      assert unclaimed_session.expired?
    end

    test "it claims a not expired session using the token" do
      unclaimed_session = no_password_sessions(:session_unclaimed)

      subject = NoPassword::SessionManager.new
      session = subject.claim(unclaimed_session.token)

      refute_nil session
      assert session.claimed?
    end

    test "it fails to claim not expired session with invalid token" do
      unclaimed_session = no_password_sessions(:session_unclaimed)

      subject = NoPassword::SessionManager.new
      session = subject.claim(unclaimed_session.token + "-invalid")

      assert_nil session

      unclaimed_session.reload
      refute unclaimed_session.claimed?
    end

    test "it fails to claim expired session" do
      unclaimed_session = no_password_sessions(:session_unclaimed)

      subject = NoPassword::SessionManager.new
      # By default sessions expires after two hours or 160 minutes
      travel_to Time.zone.now.advance(minutes: 161) do
        session = subject.claim(unclaimed_session.token)

        assert_nil session

        unclaimed_session.reload
        refute unclaimed_session.claimed?
        assert unclaimed_session.expired?
      end
    end

    test "it fails to claim already claimed session" do
      claimed_session = no_password_sessions(:session_claimed)

      subject = NoPassword::SessionManager.new
      session = subject.claim(claimed_session.token)

      assert_nil session
    end
  end
end
