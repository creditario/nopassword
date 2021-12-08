# typed: ignore
# frozen_string_literal: true

require "active_support/concern"

module NoPassword
  module Concerns
    module ControllerHelpers
      extend ActiveSupport::Concern

      def current_session
        session_id = session[session_key]
        @session ||= NoPassword::Session.find(session_id)
      end

      def signed_in_session?
        current_session.present?
      end

      def sign_in(session, key = nil, data = nil)
        current_time = Time.zone.now
        if session.claimed_at && session.expires_at > current_time
          session[session_key] = session.id

          if key.present? && data.present?
            session[session_key(key)] = data
          end
        end
        session
      end

      def sign_out(key = nil)
        session.delete(session_key)
        session.delete(session_key(key)) if key.present?
        @session = nil
        return true
      end

      protected
      
      def session_key(value = "id")
        return "—-no_password_session_#{value}"
      end
    end
  end
end
