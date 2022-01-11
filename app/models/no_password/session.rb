# frozen_string_literal: true

module NoPassword
  class Session < ApplicationRecord
    validates :token, :user_agent, :remote_addr, :email, presence: true

    def claimed?
      claimed_at.present?
    end

    def expired?
      current_time = Time.zone.now

      expires_at < current_time
    end

    def invalid?
      claimed? || expired?
    end
  end
end
