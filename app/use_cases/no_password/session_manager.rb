# frozen_string_literal: true

module NoPassword
  class SessionManager
    def create(user_agent, email, remote_addr, return_url = nil)
      expire_unclaimed_session(email)

      Session.create(
        user_agent: user_agent,
        email: email,
        expires_at: NoPassword.configuration.session_expiration.from_now,
        token: generate_friendly_token,
        remote_addr: remote_addr,
        return_url: return_url
      )
    end

    def claim(token)
      current_time = Time.zone.now

      session = Session
        .where(token: token, claimed_at: nil)
        .where("expires_at > ?", current_time)
        .first

      if session.present?
        session.claimed_at = current_time
        session.save

        return session
      end

      nil
    end

    private

    def expire_unclaimed_session(email)
      current_time = Time.zone.now

      Session
        .where(email: email, claimed_at: nil)
        .where("expires_at > ?", current_time)
        .update_all(expires_at: current_time)
    end

    def generate_friendly_token
      "#{SecureRandom.alphanumeric(4)}-#{SecureRandom.random_number(10_000)}-#{SecureRandom.alphanumeric(4)}"
    end
  end
end
