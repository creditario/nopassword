require "test_helper"

module NoPassword
  class SessionManagerTest < ActiveSupport::TestCase
    REMOTE_ADDR = "127.0.0.1"

    test "it creates a new session" do
      existing_session = no_password_sessions(:session_one)
      user_agent = existing_session.user_agent
      email = existing_session.email

      subject = NoPassword::SessionManager.new

      session = subject.create(user_agent, email, REMOTE_ADDR)

      refute_nil session
      assert_nil session.claimed_at
      refute_nil session.token
    end

    test "it expires previous unclaimed session and creates a new one" do
      existing_session = no_password_sessions(:session_one)
      user_agent = existing_session.user_agent
      email = existing_session.email

      NoPassword::Session.where(user_agent: user_agent, email: email).destroy_all

      subject = NoPassword::SessionManager.new

      subject.create(user_agent, email, REMOTE_ADDR)

      assert_equal 1, NoPassword::Session.where(user_agent: user_agent, email: email).count
      assert_equal 1, query_unclaimed_not_expired_session_count(user_agent, email)

      session = subject.create(user_agent, email, REMOTE_ADDR)

      assert_equal 2, NoPassword::Session.where(user_agent: user_agent, email: email).count
      assert_equal 1, query_unclaimed_not_expired_session_count(user_agent, email)
      assert_equal session.id, query_unclaimed_not_expired_session(user_agent, email).ids.first
    end

    test "it claims a not expired session using the token" do
      existing_session = no_password_sessions(:session_one)
      user_agent = existing_session.user_agent
      email = existing_session.email
      NoPassword::Session.where(user_agent: user_agent, email: email).destroy_all

      subject = NoPassword::SessionManager.new

      session = subject.create(user_agent, email, REMOTE_ADDR)

      assert_equal 1, NoPassword::Session.where(user_agent: user_agent, email: email).count
      assert_equal 1, query_unclaimed_not_expired_session_count(user_agent, email)

      subject.claim(session.token, email)

      assert_equal 0, query_unclaimed_not_expired_session_count(user_agent, email)
    end

    test "it fails to claim not expired session with invalid token" do
      existing_session = no_password_sessions(:session_one)
      user_agent = existing_session.user_agent
      email = existing_session.email

      subject = NoPassword::SessionManager.new

      assert_equal 1, NoPassword::Session.where(user_agent: user_agent, email: email).count
      assert_equal 1, query_unclaimed_not_expired_session_count(user_agent, email)

      subject.claim("Invalid-Token", email)

      assert_equal 1, query_unclaimed_not_expired_session_count(user_agent, email)
    end

    test "it fails to claim expired session" do
      existing_session = no_password_sessions(:session_one)
      user_agent = existing_session.user_agent
      email = existing_session.email

      subject = NoPassword::SessionManager.new

      assert_equal 1, NoPassword::Session.where(user_agent: user_agent, email: email).count
      assert_equal 1, query_unclaimed_not_expired_session_count(user_agent, email)

      travel_to Time.zone.now.advance(minutes: 20)

      subject.claim(existing_session.token, email)

      assert_equal 1, query_unclaimed_expired_session_count(user_agent, email)
    end

    test "it fails to claim already claimed session" do
      existing_session = no_password_sessions(:session_one)
      user_agent = existing_session.user_agent
      email = existing_session.email

      subject = NoPassword::SessionManager.new

      assert_equal 1, NoPassword::Session.where(user_agent: user_agent, email: email).count
      assert_equal 1, query_unclaimed_not_expired_session_count(user_agent, email)

      result = subject.claim(existing_session.token, email)

      refute_nil result
      assert_equal 0, query_unclaimed_not_expired_session_count(user_agent, email)

      result = subject.claim(existing_session.token, email)

      assert_nil result
    end

    private

    def query_unclaimed_expired_session_count(user_agent, email)
      NoPassword::Session
        .where(user_agent: user_agent, email: email, claimed_at: nil)
        .where("expires_at < ?", Time.zone.now)
        .count
    end

    def query_unclaimed_not_expired_session_count(user_agent, email)
      NoPassword::Session
        .where(user_agent: user_agent, email: email, claimed_at: nil)
        .where("expires_at > ?", Time.zone.now)
        .count
    end

    def query_unclaimed_not_expired_session(user_agent, email)
      NoPassword::Session
        .where(user_agent: user_agent, email: email, claimed_at: nil)
        .where("expires_at > ?", Time.zone.now)
    end
  end
end
