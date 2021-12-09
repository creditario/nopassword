# typed: ignore
# frozen_string_literal: true

require "active_support/concern"

module NoPassword
  module Concerns
    module ControllerHelpers
      extend ActiveSupport::Concern

      def current_session
        session_id = session[session_key]
        @session ||= NoPassword::Session.find_by_id(session_id)
      end

      def signed_in_session?
        current_session.present?
      end

      def sign_in(input_session, key = nil, data = nil)
        current_time = Time.zone.now

        if input_session.claimed_at && input_session.expires_at > current_time
          session[session_key] = input_session.id

          if key.present? && data.present?
            session[session_key(key)] = data
          end
          input_session
        end
      end

      def sign_out(key = nil)
        session.delete(session_key)
        session.delete(session_key(key)) if key.present?
        @session = nil
        true
      end

      protected

      def session_key(value = "id")
        "—-no_password_session_#{value}"
      end
    end
  end
end
