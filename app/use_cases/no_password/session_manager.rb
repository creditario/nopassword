# frozen_string_literal: true

module NoPassword
  class SessionManager
    def create(user_agent, email, remote_addr, return_url = nil)
      expire_unclaimed_session(user_agent, email)

      Session.create(
        user_agent: user_agent,
        email: email,
        expires_at: Time.zone.now.advance(minutes: NoPassword.configuration.session_expiration),
        token: generate_friendly_token,
        remote_addr: remote_addr,
        return_url: return_url
      )
    end

    def claim(token, email)
      current_time = Time.zone.now

      session = Session
        .where(token: token, email: email, claimed_at: nil)
        .where("expires_at > ?", current_time)
        .first

      session.update(claimed_at: current_time) if session.present?
      session
    end

    private

    def expire_unclaimed_session(user_agent, email)
      current_time = Time.zone.now
      sessions = Session
        .where(user_agent: user_agent, email: email, claimed_at: nil)
        .where("expires_at > ?", current_time)

      sessions.each { |session| session.update(expires_at: current_time) }
    end

    def generate_friendly_token
      "#{SecureRandom.alphanumeric(4)}-#{SecureRandom.random_number(10_000)}-#{SecureRandom.alphanumeric(4)}"
    end
  end
end
